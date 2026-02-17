class Personasforexadoc < ApplicationRecord
  belongs_to :personasformulariosexamen


  has_attached_file :documento_examen, style: {medium: '300x300!',
                                              thumb: '100x100!',
                                              dato: '180x130!',
                                              dato2: '130x130!'}, whiny: false

  validates_attachment_content_type :documento_examen, content_type: ['application/pdf','image/jpeg','image/png','image/pjpeg'], :message=>"El formato del archivo debe ser (PNG,JPG,JPEG,PDF)"
  validates_attachment_size :documento_examen, :less_than => 5000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 5 Megabytes"
  validates :documento_examen, attachment_presence: true, presence: true
  validates_presence_of :descripcion
end
