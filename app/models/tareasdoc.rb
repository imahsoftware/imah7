class Tareasdoc < ApplicationRecord
  belongs_to :tarea

  validates_presence_of :descripcion, :tareadoc

  has_attached_file :tareadoc, styles: { medium: '120x120!', thumb: '100x100!', large: '500x500!' }, whiny: false

  validates_attachment_content_type :tareadoc, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :tareadoc, less_than: 15000.kilobytes, message: "El tamaño del archivo no puede ser superior a 10 Megabytes"
end
