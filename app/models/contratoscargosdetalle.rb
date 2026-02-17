class Contratoscargosdetalle < ApplicationRecord
  belongs_to :contratoscargo
  belongs_to :user

  validates_presence_of :nota, message: "* Obligatorio"

end
