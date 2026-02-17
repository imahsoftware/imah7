class Soportesnotasimagen < ApplicationRecord
  belongs_to :soportesnota
  belongs_to :user

  validates_presence_of :descripcion, :docsoportesnota

  has_attached_file :docsoportesnota
  validates_attachment_content_type :docsoportesnota, content_type: /\A*\/.*\Z/
  validates_attachment_size :docsoportesnota, :less_than => 15000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 10 Megabytes"
end
