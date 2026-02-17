class Contratosperinvdetalle < ApplicationRecord
  belongs_to :contratosperinventario

  has_many :contratosperdetallesdocs

  validates_presence_of :item, :nro_placa, :estado_item, :valor

  def valida_devolucion(params)
    @params = params
  end

  validates_presence_of :observacion_devolucion, if: :valida_obs?
  def valida_obs?
    @params == 'DEVOLUCION' ? true : false
  end
end
