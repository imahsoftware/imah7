# app/models/interactividad.rb
class Interactividad < ApplicationRecord
  belongs_to :interventoria
  belongs_to :user, optional: true
  has_many :interactobservaciones, dependent: :destroy
  has_many :interactimagenes,      dependent: :destroy

  validates :actividad, presence: true

  # ¿Es la actividad de Seguridad Social?
  def actividad_ss?
    actividad.to_s.upcase.include?('SEGURIDAD SOCIAL')
  end

  # ¿Puede cargar observaciones sobre ella? (solo SS)
  def autoriza_observaciones?
    actividad_ss?
  end

  # Consecutivo siguiente dentro del mismo informe
  def siguiente_consecutivo
    sig = interventoria.interactividades
                       .where("consecutivo = ?", consecutivo.to_i + 1)
                       .first
    sig&.consecutivo || 0
  end

  # Consecutivo anterior
  def consecutivo_anterior
    ant = interventoria.interactividades
                       .where("consecutivo = ?", consecutivo.to_i - 1)
                       .first
    ant&.consecutivo || 0
  end

  # ¿Tiene soporte digital cargado?
  def con_soporte?
    interactimagenes.exists?
  end

  # ¿Tiene observaciones?
  def con_observaciones?
    interactobservaciones.exists?
  end

  # ¿Está bloqueada?
  def bloqueada?
    bloqueado.to_s.upcase == 'SI'
  end
end
