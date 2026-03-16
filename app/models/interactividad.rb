# app/models/interactividad.rb
class Interactividad < ApplicationRecord
  belongs_to :interventoria
  belongs_to :user
  has_many :interactobservaciones, dependent: :destroy
  has_many :interactimagenes,      dependent: :destroy
end