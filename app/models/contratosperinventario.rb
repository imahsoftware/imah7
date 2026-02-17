class Contratosperinventario < ApplicationRecord
  belongs_to :contratospersona
  belongs_to :contratosperfecha
  belongs_to :user

  has_many :contratosperinvdetalles
  has_many :contratosperinvatenciones
  has_many :contratosperinvnotas
end
