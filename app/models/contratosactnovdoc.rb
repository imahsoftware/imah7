class Contratosactnovdoc < ApplicationRecord
  belongs_to :contratosactnovedad
  belongs_to :user
  validates_presence_of :descripcion, message: "* Obligatorio"

  has_attached_file :novedad, style: {medium: '300x300!',
                                             thumb: '100x100!',
                                             dato: '180x130!',
                                             dato2: '130x130!'}, whiny: false

  validates_attachment_content_type :novedad, content_type: ['application/pdf','image/jpeg','image/png','image/pjpeg'], :message=>"El formato del archivo debe ser (PNG,JPG,JPEG,PDF)"
  validates_attachment_size :novedad, :less_than => 10000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 10 Megabytes"
  validates :novedad, attachment_presence: true, presence: true

end
