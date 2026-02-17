class Contratosprefcredito < ApplicationRecord
  belongs_to :contrato
  belongs_to :contratosprefactura
  belongs_to :user


  validates_presence_of :contratosprefactura_id, :fecha, :valor, message: "* Obligatorio"
  validates_numericality_of :valor

  validate :abonos

  def abonos
    if self.valor.to_f > 0 and self.valor.to_i > self.contratosprefactura.saldo.to_f
      errors.add :valor, "El valor es superior al saldo"
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

end
