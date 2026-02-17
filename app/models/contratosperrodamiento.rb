class Contratosperrodamiento < ApplicationRecord
  belongs_to :contratospersona
  belongs_to :user

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end
end
