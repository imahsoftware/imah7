class Contratosperdotadicional < ApplicationRecord
  belongs_to :contratosperdotacion
  belongs_to :user

  validates_presence_of :elemento, :cantidad
end
