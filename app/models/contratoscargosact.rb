class Contratoscargosact < ApplicationRecord
  belongs_to :contratoscargo
  belongs_to :user

  validates_presence_of :descripcion, :estado

  # Marca esta actividad como la de pago de seguridad social del cargo
  def es_ss?
    es_pago_ss.to_s == 'SI'
  end
end
