class Contratossolnota < ApplicationRecord
  belongs_to :contratossolicitud
  belongs_to :user

  validates_presence_of :observacion, message: "* Obligatorio"

end
