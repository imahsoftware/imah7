class Contratosnodo < ApplicationRecord
  belongs_to :contrato
  belongs_to :user
  belongs_to :contratossede

  def nombre_consulta
    self.nombre.to_s
  end
end
