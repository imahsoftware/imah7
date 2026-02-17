class Eproveedoresrecibo < ApplicationRecord
  belongs_to :eproveedor
  belongs_to :eproveedorescompra
  belongs_to :user

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

  validates_presence_of :eproveedorescompra_id, :valor, :fecha
  validates_numericality_of :valor
  validate :saldofactura

  def saldofactura
    if self.eproveedorescompra_id
      proveedorescompra = Eproveedorescompra.find(self.eproveedorescompra_id)
      if self.valor.to_i > proveedorescompra.saldo.to_i
        errors.add :valor, "* El valor pagado es superior al saldo de la causacion"
      end
    end
  end

end
