# app/models/interbitacora.rb
class Interbitacora < ApplicationRecord
  belongs_to :interventoria
  belongs_to :user
end