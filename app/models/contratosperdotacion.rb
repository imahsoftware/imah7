class Contratosperdotacion < ApplicationRecord
  belongs_to :contrato
  belongs_to :contratosperfecha
  belongs_to :contratospersona
  belongs_to :user

  has_many :contratosperdotadicionales, dependent: :destroy

  def pantalon_desc
    if pantalon.blank?
      'PENDIENTE'
    else
      pantalon
    end
  end

  def camisa_desc
    if camisa.blank?
      'PENDIENTE'
    else
      camisa
    end
  end

  def zapatos_desc
    if zapatos.blank?
      'PENDIENTE'
    else
      zapatos
    end
  end

  def estado_desc
    if estado == 'PENDIENTE_ENT'
      'PENDIENTE'
    else
      estado
    end
  end

  validate :al_menos_un_campo_obligatorio

  private

  def al_menos_un_campo_obligatorio
    unless zapatos.present? || camisa.present? || pantalon.present?
      errors.add(:base, "Al menos uno de los campos (zapatos, camisa, pantalón) debe ser obligatorio.")
    end
  end
end
