class Contratospernovimagen < ApplicationRecord
  belongs_to :contratospernovedad
  belongs_to :user

  validates :novedadimagen, attachment_presence: true
  has_attached_file :novedadimagen
  validates_attachment_content_type :novedadimagen, content_type: ["application/vnd.ms-outlook; charset=binary","application/x-ole-storage","image/jpeg", "image/gif", "image/png", "application/pdf"]
  validates_attachment_size :novedadimagen, :less_than => 15000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 15 Megabytes"

end
