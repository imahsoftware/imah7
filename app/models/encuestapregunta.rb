class Encuestapregunta < ApplicationRecord
  belongs_to :encuesta
  has_many :encuestapreopciones, dependent: :destroy
  validates_presence_of :pregunta
end
