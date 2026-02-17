class Capacitacionevaluacion < ApplicationRecord
  belongs_to :capacitacion
  belongs_to :user

  has_many :capacitacionevaopciones, dependent: :destroy
end
