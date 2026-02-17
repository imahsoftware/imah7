class Visitassede < ApplicationRecord
  belongs_to :visita
  belongs_to :user
  belongs_to :contratossede

  validates_presence_of :contratossede_id, if: :valida_sede_id
  validates_presence_of :sede_direccion, if: :valida_sede_manual

  def valida_sede_id
    if Contratossede.where(["contrato_id = #{visita.contrato_id}"]).present?
      true
    end
  end

  def valida_sede_manual
    if Contratossede.where(["contrato_id = #{visita.contrato_id}"]).blank?
      true
    end
  end

end
