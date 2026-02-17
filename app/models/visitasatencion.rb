class Visitasatencion < ApplicationRecord
  belongs_to :visita
  belongs_to :user

  validates_presence_of :nombre,:identificacion,:cargo,:celular,:email

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

end
