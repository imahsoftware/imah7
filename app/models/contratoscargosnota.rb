class Contratoscargosnota < ApplicationRecord
  belongs_to :contratoscargo
  belongs_to :user

  validates_presence_of :observacion, message: "* Obligatorio"
end
