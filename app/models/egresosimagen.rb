class Egresosimagen < ApplicationRecord
  belongs_to :egreso
  belongs_to :user

  validates :egresoimagen, attachment_presence: true
  has_attached_file :egresoimagen
  validates_attachment_content_type :egresoimagen, content_type: ["application/vnd.ms-outlook; charset=binary","application/x-ole-storage","image/jpeg", "image/gif", "image/png", "application/pdf"]
  validates_attachment_size :egresoimagen, :less_than => 15000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 15 Megabytes"

end
