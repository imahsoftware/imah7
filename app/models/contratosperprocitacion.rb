class Contratosperprocitacion < ApplicationRecord
  belongs_to :contratosperproceso
  belongs_to :contratospersona
  belongs_to :user

  validates_presence_of :lugar, :fecha, :estado
  validates_presence_of :no_comparecencia, if: :valida_estado

  def valida_estado
    estado == 'NO ATENDIDA' ? true : false
  end

end
