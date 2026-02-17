class Contratosservicio < ApplicationRecord
  belongs_to :contrato
  belongs_to :user

  validates_presence_of :servicio
end
