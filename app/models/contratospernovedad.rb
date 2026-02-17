class Contratospernovedad < ApplicationRecord
  belongs_to :contratospersona
  belongs_to :contratosgrupo
  belongs_to :user
  belongs_to :tiposnovedad
  has_many :contratospernovimagenes, dependent: :destroy

  validates_presence_of :tiposnovedad_id, :fecha, :numero, :observacion, message: "* Obligatorio"

  validate :cierre

  has_attached_file :novedadimagen
  validates_attachment_content_type :novedadimagen, content_type: ["application/vnd.ms-outlook; charset=binary","application/x-ole-storage","image/jpeg", "image/gif", "image/png", "application/pdf"]
  validates_attachment_size :novedadimagen, :less_than => 5000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 5 Megabytes"

  def cierre
    if fecha.to_s != ""
      if Contratospernomina.joins(:periodosliquidacion).where(["contratospernominas.contratospersona_id = #{contratospersona_id} 
                                                                and contratospernominas.contratosgrupo_id = #{contratosgrupo_id}
                                                                and date_format('#{fecha.to_date}','%%Y-%%m-%%d') between periodosliquidaciones.inicio and periodosliquidaciones.fin"]).exists?
        if [5870,1,5381,5187].exclude?(user_id)
          errors.add :fecha, "Esta fecha ya se encuentra procesada."
        end
      else
        if [5870,1,5381,5187].include?(user_id)
          periodo = Periodosliquidacion.where(["termino = '#{self.contratospersona.datogrupotermino.to_s}' and date_format('#{fecha.to_date}','%%Y-%%m-%%d') between periodosliquidaciones.inicio and periodosliquidaciones.fin"])[0]
        else
          periodo = Periodosliquidacion.where(["termino = '#{self.contratospersona.datogrupotermino.to_s}' and date_format('#{fecha.to_date}','%%Y-%%m-%%d') between periodosliquidaciones.inicio and periodosliquidaciones.fin and estado = 'P'"])[0]
        end
        if periodo
          if periodo.fecha_limite.to_s == ""
            errors.add :fecha, "Esta fecha no esta habilitada (2)."
          elsif periodo.fecha_limite < fecha.to_date
            errors.add :fecha, "Esta fecha no esta habilitada."
          end
        else
          errors.add :fecha, "Esta fecha no esta habilitada (3)."
        end

        # Validacion de topes por mes en las novedades
        if [5870,1,5381,5187].include?(user_id)
          periodo = Periodosliquidacion.where(["termino = '#{self.contratospersona.datogrupotermino.to_s}' and date_format('#{fecha.to_date}','%%Y-%%m-%%d') between inicio and fin"])[0]
        else
          periodo = Periodosliquidacion.where(["termino = '#{self.contratospersona.datogrupotermino.to_s}' and date_format('#{fecha.to_date}','%%Y-%%m-%%d') between inicio and fin and estado = 'P'"])[0]
        end
        nrodias = Contratospernovedad.select("sum((nro_horas/8)) dias").where(["contratospersona_id = ? and contratosperfecha_id = ? and tiposnovedad_id in (select id from tiposnovedades where tipo = 'DEDUCCION')
                                                                                and fecha between '#{periodo.inicio}' and '#{periodo.fin}'", self.contratospersona_id, self.contratosperfecha_id])[0].dias.to_f
        if self.tiposnovedad.multiplica.to_s == 'SI'
          nrodias = nrodias + self.numero.to_f
        else
          nrodias = nrodias + (self.numero.to_f / 8.to_f).to_f
        end
        if periodo.termino.to_s == 'QUINCENAL' and nrodias > 15
          errors.add :numero, "Supera el tope de novedades por periodo (4-#{nrodias.to_s})."
        elsif periodo.termino.to_s == 'MENSUAL' and nrodias > 30
          errors.add :numero, "Supera el tope de novedades por periodo (5-#{nrodias.to_s})."
        end

      end
    end
    if Contratosperfecha.where(contratospersona_id: self.contratospersona_id, contrato_id: 24).exists? == false
      array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93]
      cadena = []
      sqlDatos = ""
      array.each do |arr|
        dato = "fecha"+arr.to_s
        if eval(dato).to_s != ""
          cadena << eval(dato).strftime("%b-%d").to_s
        end
      end
      if !cadena.size.positive?
        errors.add :fecha_real, "*** Debe seleccionar los dias de la novedad"
      end
    end
    if numero == 0 and [5870,1,5381,5187].exclude?(user_id)
      errors.add :numero, "* Debe ser mayor a cero"
    end
  end

=begin
  before_save :antesdeguardar
  def antesdeguardar
    #self.contratosgrupo_id = Contratosperfecha.where(["contratospersona_id = #{self.contratospersona_id} and (fecha_fin IS NULL OR DATE_FORMAT(fecha_fin,'%%Y-%%m') = DATE_FORMAT(CURDATE(),'%%Y-%%m') or fecha_fin >= curdate())"])[0].contratosgrupo_id rescue 0
    self.contratosgrupo_id = Contratosperfecha.where(["id = #{self.contratospersona.idperfecha}"])[0].contratosgrupo_id rescue 0
  end
=end

  def valor_novedad_dev
    if self.tiposnovedad.tipo.to_s == 'DEVENGO' or self.tiposnovedad.tipo.to_s == 'OTROS DEVENGO'
      self.valor_novedad
    else
      0
    end
  end

  def valor_novedad_ded
    if self.tiposnovedad.tipo.to_s == 'DEDUCCION' or self.tiposnovedad.tipo.to_s == 'OTROS DEDUCCION'
      self.valor_novedad
    else
      0
    end
  end

  def detallediasnovedad
    array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50]
    cadena = []
    sqlDatos = ""
    array.each do |arr|
      dato = "fecha"+arr.to_s
      if eval(dato).to_s != ""
        cadena << eval(dato).strftime("%b-%d").to_s
      end
    end
    if cadena.size.positive?
      sqlDatos << "#{cadena.join(", ")}"
    end
    return sqlDatos
  end

end
