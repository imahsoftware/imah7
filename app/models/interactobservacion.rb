# app/models/interactobservacion.rb
class Interactobservacion < ApplicationRecord
  belongs_to :interactividad
  belongs_to :user

  validates :observaciones, presence: true

  # Texto formateado con fecha y usuario (compatible con _tr que llama .obs)
  def obs
    fecha   = created_at&.strftime("%Y-%m-%d %H:%M") || '—'
    usuario = user&.username || user&.nombre || '?'
    "<strong>(#{fecha} — #{usuario})</strong> #{observaciones}".html_safe
  end
end
