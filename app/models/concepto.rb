class Concepto < ApplicationRecord
  has_many :conceptosretenciones
  has_many :eproveedorescompras

  validates_presence_of :cuenta, :descripcion
end
