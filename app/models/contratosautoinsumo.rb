class Contratosautoinsumo < ApplicationRecord
  belongs_to :contrato
  belongs_to :insumo
  belongs_to :user

  validates_presence_of :insumo_id, message: "* Obligatorio"

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

  def descinsumo
    self.insumo.insumodetalle rescue nil
  end

end
