class Contratosperuser < ApplicationRecord
  belongs_to :contratospersona
  belongs_to :user

  validates_presence_of :fecha_inicio, :user_id, message: "* Obligatorio"

end
