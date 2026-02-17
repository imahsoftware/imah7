class Contratosperactob < ApplicationRecord
  belongs_to :contratospersona
  belongs_to :contratosperfecha
  belongs_to :contratoscargo
  belongs_to :contratoscargosact

  def resultado_color
    if resultado == 'SI'
      "#f39c12"
    else
      "#dd4b39"
    end
  end

  validates_presence_of :observacion, if: :valida_resuesta

  def valida_resuesta
    if resultado == 'NO'
      true
    end
  end
end
