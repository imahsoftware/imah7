class Tareasactdoc < ApplicationRecord

  has_attached_file :documento_tarea, styles: { medium: '120x120!', thumb: '100x100!', large: '300x300!' }, whiny: false

  validates_attachment_content_type :documento_tarea, content_type: /\A*\/.*\Z/ # , content_type: ["application/vnd.ms-outlook; charset=binary","application/x-ole-storage","image/jpeg", "image/gif", "image/png", "application/pdf"]
  validates_attachment_size :documento_tarea, less_than: 35000.kilobytes, message: "El tamaño del archivo no puede ser superior a 35 Megabytes"

  validates_presence_of :descripcion, :documento_tarea
end


