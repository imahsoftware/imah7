class Empresassede < ApplicationRecord
  belongs_to :empresa
  belongs_to :municipio
  belongs_to :user
  has_many :contratoscargos
  has_many :contratosusers
  has_many :contratosinsumos
  has_many :contratosmaquinarias
  has_many :contratosotros
  has_many :contratospagos

  validates_presence_of :nombre, message: "* Obligatorio"

end
