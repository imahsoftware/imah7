class Interventoria < ApplicationRecord
  belongs_to :contrato
  belongs_to :contratosperfecha
  belongs_to :user
  has_many :interactividades, dependent: :destroy
  has_many :interbitacoras,   dependent: :destroy

  # ─── ESTADOS ────────────────────────────────────────────────────────────────
  ESTADOS = %w[PENDIENTE REVISION REVISIONFINALINT REVISIONFINALGH
               APROBADO APROBADOGH APROBADOCONT APROBADOFINAL
               RECHAZADO RECHAZADOGH RECHAZADOCONT RECHAZADOFINALINT
               RECHAZADOFINALGH TESORERIA].freeze

  # ─── BUSQUEDA ───────────────────────────────────────────────────────────────
  # Busca por identificacion o nombre del contratista via contratosperfecha
  def self.search(identificacion)
    if identificacion.to_s.present?
      termino = "%#{identificacion.to_s.upcase.gsub(' ', '%')}%"
      joins(contratosperfecha: :contratospersona)
        .where("UPPER(contratospersonas.identificacion) LIKE ? OR UPPER(contratospersonas.autobuscar) LIKE ?",
               termino, termino)
        .order(anno: :desc, mes: :desc)
    else
      where("DATE(created_at) = ?", Date.today).order(created_at: :asc)
    end
  end

  # ─── PERIODOS DISPONIBLES ──────────────────────────────────────────────────
  # Genera lista de {ano:, mes:} desde fecha_inicio del contrato hasta hoy
  # Reemplaza la tabla fechascontables de Oracle
  def self.periodos_disponibles(fecha_inicio, fecha_fin = nil)
    return [] if fecha_inicio.nil?
    inicio  = fecha_inicio.beginning_of_month
    fin     = [fecha_fin, Date.today].compact.min.beginning_of_month
    periodos = []
    current  = inicio
    while current <= fin
      periodos << { ano: current.year.to_s, mes: current.month.to_s.rjust(2, '0') }
      current = current.next_month
    end
    periodos.reverse
  end


  def acceso
    if self.estado.to_s == "REVISION" or self.estado.to_s == "APROBADO"
      return 'N'
    else
      return 'S'
    end
  end

  # ─── CONTROL DE ACCESO ────────────────────────────────────────────────────
  # Reemplaza el método acceso del original (devolvía 'S'/'N')
  def editable?
    !%w[REVISION APROBADO APROBADOGH APROBADOCONT
        REVISIONFINALGH REVISIONFINALINT].include?(estado.to_s)
  end

  def bloqueado?
    bloqueado.to_s == 'S'
  end

  # ─── VALIDACION DEL INFORME ───────────────────────────────────────────────
  # Reemplaza fnc_validainformes (Oracle) — misma lógica en Ruby puro
  # Retorna string HTML con errores, o "" si todo está correcto
  def validainforme
    errores = []

    if interactividades.empty?
      errores << "• No tiene obligaciones/actividades registradas."
    end

    sin_desarrollo = interactividades.where("desarrollo IS NULL OR desarrollo = ''").count
    if sin_desarrollo > 0
      errores << "• Tiene #{sin_desarrollo} obligacion(es) sin desarrollo diligenciado."
    end

    act_ss = interactividades.where("actividad LIKE ?", '%PAGOS%DE%SEGURIDAD%SOCIAL%')
    if act_ss.exists?
      sin_imagen = act_ss.select { |a| !a.interactimagenes.exists? }
      if sin_imagen.any?
        errores << "• La actividad de Pagos de Seguridad Social no tiene soporte digital cargado."
      end
    else
      errores << "• No se encontró la actividad de Pagos de Seguridad Social."
    end

    if salud.to_i == 0
      errores << "• El valor de salud no ha sido diligenciado en la cuenta de cobro."
    end

    if observaciones.blank?
      errores << "• Las observaciones y forma de pago son obligatorias."
    end

    return "".html_safe if errores.empty?
    items = errores.map { |e| "<li style=\"margin:3px 0;\">#{e}</li>" }.join
    "<ul style=\"margin:4px 0 0 0; padding-left:18px; list-style:disc;\">#{items}</ul>".html_safe
  end

  # ─── NOMBRE DEL INTERVENTOR/SUPERVISOR ───────────────────────────────────
  # Reemplaza nombreinterventor que buscaba en tabla empleados Oracle
  def nombreinterventor
    supervisor = contratosperfecha&.contratospersona
    return '' unless supervisor
    "#{supervisor.nombre_completo}<br>#{supervisor.cargo}".html_safe
  end

  # ─── LÍMITES FISCALES (UVT) ───────────────────────────────────────────────
  def limite_prepagada
    (16 * Sifi.find(58).valor.to_i) rescue 0
  end

  def limite_vivienda
    (100 * Sifi.find(58).valor.to_i) rescue 0
  end

  def limite_dependencia
    (32 * Sifi.find(58).valor.to_i) rescue 0
  end

  # ─── CALCULOS FISCALES ───────────────────────────────────────────────────
  def salud_auto
    base = (valor_mes.to_i * 40) / 100
    (base * 12.5 / 100).to_i
  end

  def arl_auto
    base = (valor_mes.to_i * 40) / 100
    (base * 0.522 / 100).to_i
  end

  def pension_auto
    base = (valor_mes.to_i * 40) / 100
    (base * 16 / 100).to_i
  end

  # Calcula todos los valores de retención en un solo método
  # Reemplaza los 8 métodos obs_* duplicados del controller original
  def self.calcular_retencion(valor_mes:, salud:, arl:, pension:,
                              interes_credito:, salud_prepagada:, dependientes:,
                              afc:, voluntarias:, base_uvt_config:,
                              retefuente383_config:, retefuente384_config:)
    valor_mes      = valor_mes.to_i
    salud          = salud.to_i
    arl            = arl.to_i
    pension        = pension.to_i
    interes_credito= interes_credito.to_i
    salud_prepagada= salud_prepagada.to_i
    dependientes   = dependientes.to_i
    afc            = afc.to_i
    voluntarias    = voluntarias.to_i

    subtotal      = salud + arl + interes_credito + salud_prepagada + dependientes
    subtotalr     = pension + afc + voluntarias
    valortotal    = valor_mes - subtotal - subtotalr
    renta         = (valortotal * 25) / 100
    base_retefuente = valortotal - renta
    base_uvt      = (base_retefuente.to_f / base_uvt_config.to_f).round(0).to_i

    # Método 383: tabla de rangos UVT
    vlr1           = calcular_uvt_383(base_uvt)
    retefuente383  = (vlr1 * retefuente383_config.to_f).round(-3).to_i

    # Método 384
    base384        = ((valor_mes - salud - arl - pension).to_f / retefuente384_config.to_f).round(2)
    retefuente384  = calcular_retefuente384(base384, retefuente384_config)

    total = if retefuente383 > retefuente384
              valor_mes - retefuente383
            else
              valor_mes - retefuente384
            end

    {
      subtotal:        subtotal,
      subtotalr:       subtotalr,
      subtotalt:       valortotal,
      renta:           renta,
      base_retefuente: base_retefuente,
      base_uvt:        base_uvt,
      retefuente383:   retefuente383,
      retefuente384:   retefuente384,
      total:           total
    }
  end

  def self.calcular_uvt_383(base_uvt)
    # Tabla de rangos UVT - ajustar según tabla vigente
    # Retorna el factor para aplicar
    case base_uvt
    when 0..95     then 0
    when 96..150   then (base_uvt - 95) * 19.0 / 100
    when 151..360  then (base_uvt - 150) * 28.0 / 100 + 10.45
    when 361..640  then (base_uvt - 360) * 33.0 / 100 + 69.25
    when 641..945  then (base_uvt - 640) * 35.0 / 100 + 161.65
    when 946..2300 then (base_uvt - 945) * 37.0 / 100 + 268.40
    else                (base_uvt - 2300) * 39.0 / 100 + 769.55
    end
  end

  def self.calcular_retefuente384(base384, config)
    # Implementar según tabla 384 vigente
    (base384 * config.to_f).round(-3).to_i rescue 0
  end

  # ─── HELPERS DE PRESENTACION ─────────────────────────────────────────────
  MESES = %w[_ Enero Febrero Marzo Abril Mayo Junio Julio
             Agosto Septiembre Octubre Noviembre Diciembre].freeze

  def desc_mes
    MESES[mes.to_i] || '------'
  end

  def desc_mes_upcase
    desc_mes.upcase
  end

  def periodo_actual
    "Mes: #{desc_mes_upcase} - Año: #{anno}"
  end

  def inter_annomes
    "#{anno}#{mes.to_s.rjust(2, '0')}" rescue nil
  end

  # ─── DATOS DEL CONTRATISTA ────────────────────────────────────────────────
  def persona
    contratosperfecha&.contratospersona
  end

  def nombre_contratista
    persona&.nombre_completo || "#{persona&.nombres} #{persona&.apellidos}".strip
  end

  def identificacion_contratista
    persona&.identificacion
  end

  # ─── BITACORA ────────────────────────────────────────────────────────────
  def texto_bitacora
    nro = contrato&.nro_contrato.to_s
    "CONTRATO: #{nro} - PERIODO: #{periodo_actual}" rescue nil
  end

  def registrar_bitacora(user_id, mensaje)
    Interbitacora.create!(
      user_id:         user_id,
      interventoria_id: id,
      observacion:     "#{texto_bitacora} - #{mensaje}"
    )
  end

  # ─── ESTADO: HABILITAR INFORME FINAL ─────────────────────────────────────
  def habilitado_final?
    return false unless estado.to_s == 'PREPARAFINAL'
    actividades_ss = interactividades.where("actividad LIKE ?", '%PAGOS%DE%SEGURIDAD%SOCIAL%')
    return false if actividades_ss.empty?

    todas_con_soporte = actividades_ss.all? do |act|
      act.desarrollo.present? && act.interactimagenes.exists?
    end
    todas_con_soporte && salud.to_i > 0 && observaciones.present?
  end

  # ─── VENCIMIENTO ──────────────────────────────────────────────────────────
  def vencido?
    Time.now.year == anno.to_i && mes.to_i < Time.now.month
  end

  # ─── FIRMA ────────────────────────────────────────────────────────────────
  def firmado_supervisor?
    firma_digital_supervisor.present?
  end

  def firmado_empleado?
    firma_digital_empleado.present?
  end
end

