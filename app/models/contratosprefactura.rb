class Contratosprefactura < ApplicationRecord
  belongs_to :contrato
  belongs_to :user
  has_many :contratosprefdetalles, dependent: :destroy
  has_many :contratosprefretenciones, dependent: :destroy
  has_many :contratosprefimagenes, dependent: :destroy
  has_many :contratospagos

  def detalleprefa
    "PreFactura Nro. ".to_s + self.id.to_s + " - Factura Nro. ".to_s + self.siigo_nro.to_s + " (Saldo: " + self.saldo.to_s + ")"
  end

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

  def siigoobs
    if siigo_observacion.to_s != ""
      "<br/>ERROR: #{siigo_observacion rescue nil}" rescue nil
    end
  end

end
