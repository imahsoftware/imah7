class Egreso < ApplicationRecord
  belongs_to :eproveedor
  belongs_to :user
  belongs_to :cuenta
  belongs_to :eproveedorescompra
  belongs_to :centroscosto
  belongs_to :portafolio
  has_many :egresosdetalles
  has_many :egresosimagenes

end
