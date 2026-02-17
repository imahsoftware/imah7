class Contratosperfact < ApplicationRecord
  include InformationConcern

  belongs_to :user
  belongs_to :contratosperfecha
  belongs_to :contratospersona
  belongs_to :contrato
  belongs_to :contratosgrupo
  belongs_to :contratoscargo

  validates_presence_of :contrato_id, :contratoscargo_id, :contratosgrupo_id, :tipo, :tipo_contrato, message: "* Obligatorio"
  validate :obligatorio

  def obligatorio
    if tipo.to_s == 'DEFINITIVO' and fecha_inicio.to_s == ""
      errors.add :fecha_inicio, "La fecha de inicio es obligatorio."
    end
  end

end
