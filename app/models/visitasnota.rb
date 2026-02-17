class Visitasnota < ApplicationRecord
  belongs_to :visita
  belongs_to :user

  validates_presence_of :nota
end
