class Contratosperalerta < ApplicationRecord
  belongs_to :contratospersona
  belongs_to :user

  validates_presence_of :fecha, :observacion, :estado
end
