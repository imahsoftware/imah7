class Tarea < ApplicationRecord
  audited
  validates_presence_of :tema, :estado, :fecha_adjudicacion, :objetivo

  has_many :tareasactividades, dependent: :destroy
  has_many :tareasdocs
end
