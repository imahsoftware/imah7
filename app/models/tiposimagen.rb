class Tiposimagen < ApplicationRecord
  validates_presence_of :descripcion, :clase, message: "* Obligatorio"
end
