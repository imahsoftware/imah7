class Contratosperinvnota < ApplicationRecord
  belongs_to :contratosperinventario
  belongs_to :user

  validates_presence_of :nota
end
