class Eproveedor < ApplicationRecord
  belongs_to :municipio
  belongs_to :user
  has_many :eproveedorescompras
  has_many :eproveedorestempcompras
  has_many :eproveedorestemegresos
  has_many :eproveedoresimagenes
  has_many :eproveedoresrecibos
  has_many :eproveedorescreditos
  has_many :egresos

  validates_presence_of :tipodoc, :identificacion, :digito, :nombre, :direccion, :email
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }#, if: :is_autorization
  validate :telefono, :celular, if: :validaruntelefono
  validates :identificacion, uniqueness: {message: "Una Empresa ya existe con ese documento"}

  before_save :antesdeguardar

  def validaruntelefono
    if self.telefono.to_s == ""
      errors.add :telefono, "Debe ingresar un telefono"
    end
    if self.celular.to_s == ""
      errors.add :celular, "Debe ingresar un telefono"
    end
  end

  def antesdeguardar
    self.nombre = quita_acento(self.nombre)
    self.apellido = quita_acento(self.apellido)
    cadena = []
    cadena2 = []
    sqlDatos = ""
    sqlDatos2 = ""
    cadena << self.identificacion.to_s if self.identificacion.to_s != ""
    cadena << self.nombre.to_s if self.nombre.to_s != ""
    cadena2 << self.nombre.to_s if self.nombre.to_s != ""
    cadena << self.apellido.to_s if self.apellido.to_s != ""
    cadena2 << self.apellido.to_s if self.apellido.to_s != ""
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

  def tele
    cadena = []
    sqlDatos = ""
    cadena << self.telefono.to_s if self.telefono.to_s != ""
    cadena << self.celular.to_s if self.celular.to_s != ""
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
    if p[7].to_s != ""
      cadena << "id in (select distinct eproveedor_id from egresos where nro_egreso = '#{replacespace(p[7]).to_s.upcase.strip}')" if p[7].to_s != ""
    end
    if cadena.size.positive?
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

end