class Visitascompromiso < ApplicationRecord
  belongs_to :visita
  belongs_to :user
  has_many :visitasdocs

  validates_presence_of :fecha, :estado, :compromiso

  validates_presence_of :obs_atencion, if: :validador_obs_atencion

  def valida_campo(params)
    @params = params
  end

  def validador_obs_atencion
    @params == 'X' ? true : false
  end
end
