class Contratosperprodescargo < ApplicationRecord
  belongs_to :contratosperproceso
  belongs_to :contratospersona
  belongs_to :user

  validates_presence_of :empleado, :asear
end
