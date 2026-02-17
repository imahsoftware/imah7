class Contratosprefimagen < ApplicationRecord
  belongs_to :contratosprefactura
  belongs_to :user

  validates_presence_of :descripcion, message: "* Obligatorio"

  has_attached_file :facturasimagen, style: {medium: '300x300!',
                                     thumb: '100x100!',
                                     dato: '180x130!',
                                     dato2: '130x130!'}, whiny: false

  validates_attachment_content_type :facturasimagen, content_type: /\A*\/.*\Z/
  validates_attachment_size :facturasimagen, :less_than => 4000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 4 Megabytes"
  validates :facturasimagen, attachment_presence: true, presence: true

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end
end
