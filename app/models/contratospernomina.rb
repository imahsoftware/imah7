class Contratospernomina < ApplicationRecord

  include InformationConcern

  belongs_to :periodosliquidacion
  belongs_to :contratosgrupo
  belongs_to :contratoscargo
  belongs_to :contrato
  belongs_to :contratospersona
  belongs_to :contratosperfecha

  def totalded
    self.salud.to_f + self.pension.to_f + self.otros_deduccion.to_f + self.nov_deduccion.to_f
  end

  def totaldev
    self.salario.to_f + self.auxilio.to_f + self.otros_devengo.to_f + self.nov_devengo.to_f
  end

  def cargobyfecha
    Contratosperfecha.where(contratospersona_id: self.contratospersona_id, contratosgrupo_id: self.contratosgrupo_id, contrato_id: self.contrato_id)[0]
  end

end
