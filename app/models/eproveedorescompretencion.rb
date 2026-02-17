class Eproveedorescompretencion < ApplicationRecord
  belongs_to :eproveedorescompra
  belongs_to :tipospretencion
  belongs_to :concepto
end
