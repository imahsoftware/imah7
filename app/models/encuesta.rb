class Encuesta < ApplicationRecord
  validates_presence_of :descripcion, :estado
  has_many :encuestapreguntas, dependent: :destroy
end
