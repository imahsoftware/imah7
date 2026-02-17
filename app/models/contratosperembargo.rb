class Contratosperembargo < ApplicationRecord
  belongs_to :contratospersona
  belongs_to :tiposentidad
  belongs_to :user

  validates_presence_of :tiposentidad_id, :tipodescuento, :prestaciones, :valor, :termino_descuento, :tope, :estado


  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

end
