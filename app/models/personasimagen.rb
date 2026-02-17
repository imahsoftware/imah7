class Personasimagen < ApplicationRecord
  belongs_to :persona
  belongs_to :user

  has_attached_file :documentos, style: {medium: '300x300!',
                                  thumb: '100x100!',
                                  dato: '180x130!',
                                  dato2: '130x130!'}, whiny: false

  validates_attachment_content_type :documentos, content_type: ['application/pdf','image/jpeg','image/png','image/pjpeg'], :message=>"El formato del archivo debe ser (PNG,JPG,JPEG,PDF)"
  validates_attachment_size :documentos, :less_than => 4000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 4 Megabytes"
  validates :documentos, attachment_presence: true, presence: true
end
