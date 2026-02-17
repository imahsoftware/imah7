class Evaluacion < ApplicationRecord
  belongs_to :user

  has_many :evaluacionesdetalles, dependent: :destroy
  has_many :evaluacionescontratos, dependent: :destroy

  validates_presence_of :tema, :estado, :objetivo, :fecha_limite
  
  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end
end
