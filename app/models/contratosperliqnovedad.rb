class Contratosperliqnovedad < ApplicationRecord
  belongs_to :contratosperfecha
  belongs_to :user
  belongs_to :tiposnovedad
  belongs_to :contratosperliquidacion

  def valor_novedad_dev
    if self.tiposnovedad.tipo.to_s == 'DEVENGO' or self.tiposnovedad.tipo.to_s == 'OTROS DEVENGO'
      self.valor_novedad
    else
      0
    end
  end

  def valor_novedad_ded
    if self.tiposnovedad.tipo.to_s == 'DEDUCCION' or self.tiposnovedad.tipo.to_s == 'OTROS DEDUCCION'
      self.valor_novedad
    else
      0
    end
  end

end
