class Insumo < ApplicationRecord
  belongs_to :user
  has_many :insumosfichas

  validates_presence_of :bien_servicio, :clase, :tipo, :especificacion, :presentacion, :proveedor_id, :valor_unitario
  validate :validavalor

  before_save :antesdeguardar

  def antesdeguardar
    if self.estado.to_s == ""
      self.estado = 'PENDIENTE'
    end
  end

  def validavalor
    if self.valor_unitario.to_i == 0
      errors.add :valor_unitario, "* El valor debe ser mayor a cero"
    end
  end

  def self.search(bien_servicio,clase,page,nroreg)
    cadena = []
    if bien_servicio.to_s != ""
      cadena << " bien_servicio like '%%#{replacespace(bien_servicio.to_s.upcase.strip)}%%' "
    end
    if clase.to_s != ""
      cadena << " clase = '#{clase.to_s.upcase.strip}' "
    end
    if cadena.size > 0
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      paginate(page: page, per_page: nroreg).where("#{sqlDatos}").order('created_at desc')
    else
      paginate(page: page, per_page: nroreg).where("bien_servicio = '-1'").order('created_at desc')
      #Insumo.where("bien_servicio = '-1'", nroreg).order('id')
    end
  end

  def insumodetalle
    self.bien_servicio.to_s + " (" + self.presentacion.to_s + ")"
  end

  def insumodetalleccf
    self.id.to_s + " - " + self.bien_servicio.to_s + " (" + self.presentacion.to_s + ")"
  end

  def insumodetalleconvalor
    self.bien_servicio.to_s + " (" + self.presentacion.to_s + ")" + " - $ " + self.valor1.to_s
  end

  def insumodetallesolicitud
    ("<strong>"+self.id.to_s + ' - ' + self.bien_servicio.to_s + " (" + self.presentacion.to_s + ")</strong>").html_safe rescue nil
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
