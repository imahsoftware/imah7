class Contratosperliquidacion < ApplicationRecord
  belongs_to :contratosperfecha
  has_many :contratosperliqnovedades

  def totaldev
    cesantias.to_f + int_cesantias.to_f + vacaciones.to_f + prima.to_f + nov_devengo.to_f
  end

  def totalded
    nov_deduccion.to_f
  end

end
