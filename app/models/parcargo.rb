class Parcargo < ApplicationRecord

  has_many :parcargosdocs, dependent: :destroy

  validates_presence_of :descripcion, :estado
end
