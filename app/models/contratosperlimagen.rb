class Contratosperlimagen < ApplicationRecord
  belongs_to :contratosperfecha
  belongs_to :user

  validates :liquidacionesimagen, attachment_presence: true
  has_attached_file :liquidacionesimagen
  validates_attachment_content_type :liquidacionesimagen, content_type: ["application/vnd.ms-outlook; charset=binary","application/x-ole-storage","image/jpeg", "image/gif", "image/png", "application/pdf"]
  validates_attachment_size :liquidacionesimagen, :less_than => 15000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 15 Megabytes"

end
