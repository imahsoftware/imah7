class Eproveedoresimagen < ApplicationRecord
  belongs_to :eproveedor
  belongs_to :user

  validates_presence_of :descripcion, message: "* Obligatorio"

  has_attached_file :proveedor, style: {medium: '300x300!',
                                             thumb: '100x100!',
                                             dato: '180x130!',
                                             dato2: '130x130!'}, whiny: false

  validates_attachment_content_type :proveedor, content_type: /\A*\/.*\Z/
  validates_attachment_size :proveedor, :less_than => 10000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 10 Megabytes"
  validates :proveedor, attachment_presence: true, presence: true


end
