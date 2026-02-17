class Veriserviciosicompromiso < ApplicationRecord
  belongs_to :veriserviciositem
  belongs_to :user

  validates_presence_of :compromiso, :fecha, :observacion_estado

  validate :fecha_futura

  private

  def fecha_futura
    if fecha.present? && fecha <= Date.today
      errors.add(:fecha, "Debe ser mayor al día actual")
    end
  end
end
