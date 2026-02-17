class Conceptosretencion < ApplicationRecord
  belongs_to :concepto
  belongs_to :tipospretencion

  validates_presence_of :tipospretencion_id

end
