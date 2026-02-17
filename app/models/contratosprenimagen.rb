class Contratosprenimagen < ApplicationRecord
  belongs_to :contrato
  belongs_to :contratosgrupo
  belongs_to :user

  validates :nominasimagen, attachment_presence: true
  has_attached_file :nominasimagen, styles: { medium: "25x25!", thumb: "100x100!"}
  validates_attachment_content_type :nominasimagen, content_type: ["application/vnd.ms-outlook; charset=binary","application/x-ole-storage","image/jpeg", "image/gif", "image/png", "application/pdf"]
  validates_attachment_size :nominasimagen, :less_than => 15000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 15 Megabytes"

end
