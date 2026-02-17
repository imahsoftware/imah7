class Contratostiposnovedad < ApplicationRecord
  belongs_to :contrato
  belongs_to :tiposnovedad
end
