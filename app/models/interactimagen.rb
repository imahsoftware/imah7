# app/models/interactimagen.rb
class Interactimagen < ApplicationRecord
  belongs_to :interactividad
  belongs_to :user

  validates :descripcion, presence: true

  has_attached_file :interactividad
  validates_attachment_presence :interactividad
  validates_attachment_size :interactividad,
                            less_than: 12.megabytes,
                            message: "El archivo no puede superar 12 MB"
  validates_attachment_content_type :interactividad, content_type: [
    "application/pdf",
    "application/msword",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "application/vnd.ms-excel",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "application/vnd.ms-powerpoint",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "application/zip", "application/x-zip-compressed",
    "image/jpeg", "image/jpg", "image/png", "image/gif",
    "image/tiff", "image/tif",
    "text/csv", "text/html"
  ]
end
