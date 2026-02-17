class Visitasasistente < ApplicationRecord
  belongs_to :visita
  belongs_to :user

  validates_presence_of :nombre, :email

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end
