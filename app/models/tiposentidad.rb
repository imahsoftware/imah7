class Tiposentidad < ApplicationRecord
  belongs_to :user
  has_many :contratosperembargos

  def namecomplete
    identificacion.to_s + ' - ' + nombre.to_s
  end
end
