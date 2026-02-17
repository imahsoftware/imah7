class Formato < ApplicationRecord

  has_many :formatosvariables, dependent: :destroy
  has_many :iparametrosformatos, dependent: :destroy

  validates_presence_of :nombre, :estado, :segmento

end
