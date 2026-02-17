class Contratoscapacitacion < ApplicationRecord
  belongs_to :contrato
  belongs_to :user
  belongs_to :capacitacion

  #has_many :contratoscaparesultados, dependent: :destroy
  has_many :contratoscapapersonas, dependent: :destroy

  validates_presence_of :capacitacion_id, :contrato_id, :user_supervisor, :fecha_programacion
end
