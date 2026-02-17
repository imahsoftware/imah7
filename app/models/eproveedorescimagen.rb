class Eproveedorescimagen < ApplicationRecord
  belongs_to :eproveedorescompra
  belongs_to :user

  validates :compraimagen, attachment_presence: true
  has_attached_file :compraimagen
  validates_attachment_content_type :compraimagen, content_type: ["application/vnd.ms-outlook; charset=binary","application/x-ole-storage","image/jpeg", "image/gif", "image/png", "application/pdf"]
  validates_attachment_size :compraimagen, :less_than => 15000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 15 Megabytes"

end
