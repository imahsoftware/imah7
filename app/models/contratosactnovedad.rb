class Contratosactnovedad < ApplicationRecord
  belongs_to :contratossede
  belongs_to :user
  belongs_to :tiposevaluacion
  belongs_to :contratosactcodigo
  has_many :contratosactnovnotas
  has_many :contratosactnovdocs
  has_many :contratosactnovusers

end
