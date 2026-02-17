class Contratossolimagen < ApplicationRecord
  belongs_to :contratossolicitud
  belongs_to :user

  validates_presence_of :descripcion, message: "* Obligatorio"

  has_attached_file :solimagen, style: {medium: '300x300!',
                                        thumb: '100x100!',
                                        dato: '180x130!',
                                        dato2: '130x130!'}, whiny: false

  validates_attachment_content_type :solimagen, content_type: /\A*\/.*\Z/
  validates_attachment_size :solimagen, :less_than => 10000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 10 Megabytes"
  validates :solimagen, attachment_presence: true, presence: true

end
