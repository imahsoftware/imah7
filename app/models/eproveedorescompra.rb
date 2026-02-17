class Eproveedorescompra < ApplicationRecord
  belongs_to :eproveedor
  belongs_to :portafolio
  belongs_to :user
  belongs_to :concepto
  has_many :eproveedorescompretenciones, dependent: :destroy
  has_many :eproveedorescimagenes, dependent: :destroy

  validates_presence_of :fecha, :nro_factura, :valor, :portafolio_id,:observacion, :porc_iva, :valor_iva, :concepto_id, message: "* Obligatorio"
  validate :compra

  def compra
    if valor.to_i == 0
      errors.add :valor, "* Obligatorio"
    end
    if self.id.to_s == ""
      if Eproveedorescompra.where(eproveedor_id: eproveedor_id, nro_factura: nro_factura).exists?
        errors.add :nro_factura, "* Nro de factura ya registrada"
      end
    end
  end

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

  def detallecausacion
    "Nro Factura: (#{self.nro_factura rescue nil}) - Saldo: #{self.saldo.to_f rescue nil} --> (#{self.portafolio.nombre rescue nil})" rescue nil
  end
end
