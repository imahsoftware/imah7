class Compromiso < ApplicationRecord

  belongs_to :parcargosdoc
  belongs_to :personasformulario
  belongs_to :contratosperfecha
  belongs_to :contratospersona

  validates_presence_of :parcargosdoc_id, :personasformulario_id, :fecha_entrega, :observacion
end
