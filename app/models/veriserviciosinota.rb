class Veriserviciosinota < ApplicationRecord
  belongs_to :veriserviciositem
  belongs_to :user

  validates_presence_of :observacion
end
