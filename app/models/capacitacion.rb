class Capacitacion < ApplicationRecord
  validates_presence_of :descripcion, :estado, :objetivo, :temas, :valor_aprobado

  has_many :capacitacionevaluaciones, dependent: :destroy
  has_many :capacitaciondocs, dependent: :destroy
  has_many :contratoscapacitaciones, dependent: :destroy
  has_many :contratoscaparesultados, dependent: :destroy
  belongs_to :user



end
