class Contratospersona < ApplicationRecord
  include InformationConcern

  belongs_to :contrato
  belongs_to :contratoscargo
  belongs_to :contratosgrupo
  belongs_to :user
  has_many :contratosperexamenes
  has_many :contratosperestados
  has_many :contratospergrupos
  has_many :contratosperbitacoras
  has_many :contratospernovedades
  has_many :contratosperfechas
  has_many :contratosperdescuentos
  has_many :contratosperrodamientos
  has_many :contratosperprestamos
  has_many :contratosperembargos
  has_many :contratosperusers
  has_many :contratosperimagenes
  has_many :contratospersugerencias
  has_many :contratosperquejas
  has_many :contratosperchequeos
  has_many :contratospernotas
  has_many :contratosperalertas
  has_many :contratosperdotaciones
  has_many :contratosperprocesos, dependent: :destroy
  has_many :contratosperinventarios, dependent: :destroy

  validates_presence_of :identificacion_ss, :tipo_identificacion, :identificacion, :nombres, :apellidos, :genero, :fecha_nacimiento,
                        :direccion, :correo, :identificacion2,:fecha_nacimiento2, :fecha_expedicion,:municipio_lugar_expedicion,
                        :municipio_lugar_nacimiento,:municipio_ciudad,:estrato,:estado_civil,:nivel_educacion,:numero_hijos,#:registra_familiares, #:fecha_ingreso,:fecha_fin,
                        :banco,:tipo_cuenta,:cuenta_bancolombia,:consignar,#:grupo_nomina,:contratoscargo_id,
                        :eps,:fondo_pension,:caja_compensacion,:arl,:talla_pantalon,:talla_camisa,:talla_zapatos,:requiere_carnet,:requiere_carnet_cliente,
                        :situacion_especial,:victimas,:datos_entrega, if: :is_autorization

  validates :correo, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }#, if: :is_autorization
  validate :telefono, :movil, if: :validaruntelefono
  #validates :identificacion, uniqueness: {scope: :contrato_id, message: "Una persona ya existe con ese documento"}
  validates :identificacion, uniqueness: {message: "Una persona ya existe con ese documento"}

  def is_autorization
    if Userspermiso.where('user_id = ? and objeto_id = ?', self.user_act, 59).exists?
      false
    else
      true
    end
  end

  has_attached_file :perimagenes, styles: { medium: "25x25!", thumb: "215x215!"}
  validates_attachment_content_type :perimagenes, content_type: /\Aimage\/.*\z/

  before_save :antesdeguardar

  def validaruntelefono
    if Userspermiso.where('user_id = ? and objeto_id = ?', self.user_act, 59).exists?
      false
    else
      if self.telefono.to_s == ""
        errors.add :telefono, "Debe ingresar un telefono"
      end
      if self.movil.to_s == ""
        errors.add :movil, "Debe ingresar un telefono"
      end
      #if self.fecha_nacimiento.to_s != ""
      #  if self.edad.to_i < 18
      #    errors.add :fecha_nacimiento, "Menor de Edad. Verifique!!!"
      #  end
      #end
      if self.identificacion.to_s != "" and self.identificacion2.to_s != ""
        if self.identificacion.to_s != self.identificacion2.to_s
          errors.add :identificacion2, "* No coinciden. Verifique!!!"
          errors.add :identificacion, "* No coinciden. Verifique!!!"
        end
      end

      if self.fecha_nacimiento.to_s != "" and self.fecha_nacimiento2.to_s != ""
        if self.fecha_nacimiento.to_s != self.fecha_nacimiento2.to_s
          errors.add :fecha_nacimiento2, "* No coinciden. Verifique!!!"
          errors.add :fecha_nacimiento, "* No coinciden. Verifique!!!"
        end
      end
    end
  end

  def antesdeguardar
    self.nombres = quita_acento(self.nombres)
    self.apellidos = quita_acento(self.apellidos)
    cadena = []
    cadena2 = []
    sqlDatos = ""
    sqlDatos2 = ""
    cadena << self.identificacion.to_s if self.identificacion.to_s != ""
    cadena << self.nombres.to_s if self.nombres.to_s != ""
    cadena2 << self.nombres.to_s if self.nombres.to_s != ""
    cadena << self.apellidos.to_s if self.apellidos.to_s != ""
    cadena2 << self.apellidos.to_s if self.apellidos.to_s != ""
    cadena << self.apellido_segundo.to_s if self.apellido_segundo.to_s != ""
    cadena2 << self.apellido_segundo.to_s if self.apellido_segundo.to_s != ""
    if cadena.size.positive?
      sqlDatos << "#{cadena.join(" ")}"
      sqlDatos2 << "#{cadena2.join(" ")}"
    end
    self.autobuscar = sqlDatos
    self.nombre_completo = sqlDatos2
  end

  def quita_acento(dato)
    valor = dato.gsub('Á', 'A') rescue nil
    valor = valor.gsub('É', 'E') rescue nil
    valor = valor.gsub('Í', 'I') rescue nil
    valor = valor.gsub('Ó', 'O') rescue nil
    valor = valor.gsub('Ú', 'U') rescue nil
    #valor = valor.gsub('Ñ', 'N') rescue nil
    valor.to_s
  end

  def persona_autobuscar=(autobuscar)
    self.persona = Persona.find_by(autobuscar: autobuscar) if autobuscar.present?
  end

  def edad
    unless self.fecha_nacimiento.nil?
      now = Time.zone.now.to_date
      age = now.year - self.fecha_nacimiento.year - ((now.month > self.fecha_nacimiento.month || (now.month == self.fecha_nacimiento.month && now.day >= self.fecha_nacimiento.day)) ? 0 : 1)
      age
    end
  end

  def responsable
    if self.user_asignado.to_i > 0
      User.find(self.user_asignado).nombre rescue nil
    end
  end

  def tele
    cadena = []
    sqlDatos = ""
    cadena << self.telefono.to_s if self.telefono.to_s != ""
    cadena << self.movil.to_s if self.movil.to_s != ""
    if cadena.size.positive?
      sqlDatos << " #{cadena.join(" - ")}"
    end
    sqlDatos
  end

  def self.search(*p)
    cadena = []
    if p[0].to_s != ""
      cadena << "autobuscar like '%%#{replacespace(p[0]).to_s.upcase.strip}%%'" if p[0].to_s != ""
    end
    if cadena.size.positive?
      if p[6].to_s != ""
        cadena << " id in (select contratospersona_id from contratosperfechas where contrato_id = #{p[6]} and (fecha_fin is null or fecha_fin >= now())) "
      else
        if p[4] == false and p[5] == false
          cadena << " id in (select contratospersona_id from contratosperusers where user_id = #{p[1]} and fecha_fin is null) "
        end
      end
      sqlDatos = ''
      sqlDatos = " #{cadena.join(' and ')}"
      paginate(page: p[2], per_page: p[3]).where(sqlDatos.to_s).order('autobuscar asc')
    else
      paginate(page: p[2], per_page: p[3]).where(["id = '-1'"])
    end
  end

  def self.replacespace(campo)
    b = campo.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b
  end

  def tipodoc_identificacion
     tipo_identificacion.to_s + ' Nro. ' + camponumerico_iden(identificacion).to_s rescue nil
  end

  def datogrupotermino
    Contratosperfecha.where(["contratospersona_id = #{id} and estado = 'ACTIVO' and (fecha_fin IS NULL OR DATE_FORMAT(fecha_fin,'%%Y-%%m') = DATE_FORMAT(CURDATE(),'%%Y-%%m') or fecha_fin >= curdate())"])[0].contratosgrupo.termino.to_s rescue nil
  end

  def datoscontratoid
    #Contratosperfecha.where(["contratospersona_id = #{id} and estado = 'ACTIVO' AND (fecha_fin IS NULL OR DATE_FORMAT(fecha_fin,'%%Y-%%m') = DATE_FORMAT(CURDATE(),'%%Y-%%m') or fecha_fin >= curdate())"])[0].contrato_id.to_s rescue nil
    Contratosperfecha.find(idperfecha).contrato_id.to_s rescue nil
  end

  def direcciontelefono
    self.direccion.to_s + ' Tel: ' + self.movil.to_s rescue nil
  end

  def camponumerico_iden(valor)
    number_to_currency(valor, precision: 2, unit: "", delimiter: ".")
  end

  ################################################################################################
  # METODO DE CONVERSION APORTES EN LINEA
  ################################################################################################

  def aportes_TipoIdAportante
    Iparametro.where(campo: 'tipo_identificacion', descripcion: tipo_identificacion).first.codigo_dian rescue nil
  end
end
