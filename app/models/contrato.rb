class Contrato < ApplicationRecord
  audited
  belongs_to :empresa
  belongs_to :tiposcontrato
  belongs_to :user
  belongs_to :municipio
  has_many :contratosimagenes
  has_many :contratosmodificaciones
  has_many :contratosobservaciones
  has_many :contratospagos
  has_many :contratosusers
  has_many :contratosinsumos
  has_many :contratoscargos
  has_many :contratossedes
  has_many :contratosmaquinarias
  has_many :contratosotros
  has_many :contratossolicitudes
  has_many :contratospersonas
  has_many :contratosprefacturas
  has_many :contratosprefdebitos
  has_many :contratosprefcreditos
  has_many :contratosactividades
  has_many :contratostiposnovedades
  has_many :contratosretenciones
  has_many :contratosautoinsumos
  has_many :contratosperdescuentos
  has_many :contratosperrodamientos
  has_many :contratosperprestamos
  has_many :contratosperembargos
  has_many :contratosgrupos
  has_many :contratosproyectos
  has_many :contratossecciones, dependent: :destroy
  has_many :contratoscapacitaciones, dependent: :destroy
  has_many :contratosservicios

  validates_presence_of :nro_contrato, :objeto, :tiposcontrato_id, :valor, :plazo_mes, :plazo_dia, :fecha_inicio, :fecha_fin, :estado


  def claseinsumos
    if self.tiposcontrato_id.to_i == 24
      'COLOMBIA COMPRA EFICIENTE'
    else
      'GENERAL'
    end
  end

  def nombrebyuser
    self.nro_contrato.to_s + ' - ' + self.empresa.nombre.to_s + ' (' + self.claseinsumos.to_s + ' - ID - ' + self.id.to_s + ')' rescue nil
  end

  def nombrecontrato
    self.nro_contrato.to_s + ' - ' + self.empresa.nombre.to_s rescue nil
  end

  def nombreempresa
    self.empresa.identnombre rescue nil
  end

  def validacionfactura
    dato = ""
    if municipio_id.to_s == ""
      dato = dato + ' * ' + "NO hay Municipio registrado<br/>"
    end
    if direccion.to_s == ""
      dato = dato + ' * ' + "NO hay Dirección Registrada<br/>"
    end
    if telefono_empresa.to_s == ""
      dato = dato + ' * ' + "NO hay Telefono Empresa Registrado<br/>"
    end
    if email_empresa.to_s == ""
      dato = dato + ' * ' + "NO hay Email Empresa Registrado<br/>"
    end
    if contacto_nombre.to_s == ""
      dato = dato + ' * ' + "NO hay Contacto Nombre Registrado<br/>"
    end
    if contacto_apellido.to_s == ""
      dato = dato + ' * ' + "NO hay Contacto Apellido Registrado<br/>"
    end
    if contacto_email.to_s == ""
      dato = dato + ' * ' + "NO hay Contacto Email Registrado<br/>"
    end
    return dato
  end

  def fechafinal
    if fechamasmodi.to_s == ""
      return fecha_fin
    else
      return fechamasmodi
    end
  end
end

