class Contratosperprestamo < ApplicationRecord
  belongs_to :contratospersona
  belongs_to :user

  validates_presence_of :valor, :termino_descuento, :cuota, :estado

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end
end