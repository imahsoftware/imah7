class Soportesnota < ApplicationRecord
  belongs_to :soporte
  belongs_to :user
  has_many :soportesnotasimagenes, dependent: :destroy

  validates_presence_of :observaciones
end
