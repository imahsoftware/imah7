class Veriserviciosagenda < ApplicationRecord
  belongs_to :veriservicio
  belongs_to :user

  has_many :veriserviciosusers
  has_many :veriserviciosasoportes

  validates_presence_of :fecha_reprogramacion, :nota
  validate :fecha_futura

  def validacion_conclusion(params)
    @params = params
  end

  validates_presence_of :conclusion, if: :valida_existe_conclusion?

  def valida_existe_conclusion?
    @params == 'CONCLUSION' ? true : false
  end

  private

  def fecha_futura
    if fecha_reprogramacion.present? && fecha_reprogramacion < Date.today
      errors.add(:fecha_reprogramacion, "Debe ser mayor al día actual")
    end
  end
end
