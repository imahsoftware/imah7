class Contratossolepp < ApplicationRecord
  belongs_to :contrato
  belongs_to :user
  belongs_to :municipio
  has_many :contratossoleppsdetalles, dependent: :destroy
  has_many :contratossoleppsbitacoras, dependent: :destroy
  has_many :contratossoleppsdocs, dependent: :destroy
  has_many :contratossoleppsatenciones, dependent: :destroy

  validates_presence_of :contrato_id, :requiere

  validates_presence_of :cedula, :nombre, :direccion, :telefono, :municipio_id, if: :valida_campos_epp

  def valida_campos(params)
    @params = params
  end

  def valida_campos_epp
    @params == 'VALIDADOR' ? true : false
  end
end
