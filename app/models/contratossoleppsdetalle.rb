class Contratossoleppsdetalle < ApplicationRecord
  belongs_to :contratossolepp

  validates_presence_of :item, :cantidad
  validates_numericality_of :cantidad
end
