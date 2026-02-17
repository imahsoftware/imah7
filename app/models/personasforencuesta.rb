class Personasforencuesta < ApplicationRecord
  belongs_to :encuesta
  belongs_to :encuestapregunta
  belongs_to :personasformulario
end
