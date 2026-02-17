class Contratossolotro < ApplicationRecord
  belongs_to :contratossolicitud
  belongs_to :user
  belongs_to :insumo

  validates_presence_of :insumo_id, message: "* Obligatorio"

  before_save :antesdeguardar

  def antesdeguardar
    cant = 0
    Contratossede.where(["contrato_id = #{self.contratossolicitud.contrato_id}"]).each do |a|
      cant = cant + eval("self.cantsede_"+a.ordensede.to_s).to_f
    end
    self.cantidad = cant
    self.cantidad_real = self.cantidad
    #logger.error("ingreso..."+self.contratossolicitud.contrato.tiposcontrato_id.to_s)
    if self.contratossolicitud.contrato.tiposcontrato_id.to_i == 24
      self.precio_unitario = self.insumo.valor1.to_f
    else
      self.precio_unitario = self.insumo.valor_unitario.to_f
    end
    self.total = (self.cantidad_real * self.precio_unitario)
  end

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

  def nombreinsumo
    self.insumo.bien_servicio rescue nil
  end

end
