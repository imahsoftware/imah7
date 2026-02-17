class Capacitaciondoc < ApplicationRecord
  belongs_to :capacitacion

  validates_presence_of  :tipo

  validates_presence_of :descripcion, if: :valida_tipo_url
  validates_presence_of :descripcion, :capacitaciondoc, if: :valida_tipo_documento

  has_attached_file :capacitaciondoc, styles: { medium: '120x120!', thumb: '100x100!', large: '300x300!' }, whiny: false

  validates_attachment_content_type :capacitaciondoc, content_type: ['application/pdf','image/jpeg','image/png','image/pjpeg'], :message=>"El formato del archivo debe ser (PNG,JPG,JPEG,PDF)"
  validates_attachment_size :capacitaciondoc, less_than: 25000.kilobytes, message: "El tamaño del archivo no puede ser superior a 25 Megabytes"

  def valida_tipo_documento
    tipo == 'DOCUMENTO' ? true : false
  end

  def valida_tipo_url
    ['VIDEO','LINK'].include?(tipo) ? true : false
  end
end
