# app/models/interactimagen.rb
class Interactimagen < ApplicationRecord
  belongs_to :interactividad
  belongs_to :user
end