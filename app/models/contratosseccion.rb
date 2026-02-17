class Contratosseccion < ApplicationRecord
  belongs_to :contrato
  belongs_to :user
  belongs_to :municipio
  belongs_to :contratosgrupo
  belongs_to :contratoscargo
  has_many :contratossecusers

  validates_presence_of :descripcion, :contratosgrupo_id, :contratoscargo_id, :municipio_id, :cantidad
  validates_numericality_of :cantidad

  def muni
    self.municipio.autobuscar.to_s + ' (' + self.municipio.region.to_s + ')'
  end

  def detalleinforme
    self.descripcion.to_s + ' ( ' + self.muni.to_s + ' )'
  end

end
