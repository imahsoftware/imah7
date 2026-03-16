# app/models/interactobservacion.rb
class Interactobservacion < ApplicationRecord
  belongs_to :interactividad
  belongs_to :user
end