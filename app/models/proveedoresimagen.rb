class Proveedoresimagen < ApplicationRecord
  belongs_to :proveedor
  belongs_to :user
  belongs_to :tiposimagen

  validates_presence_of :tiposimagen_id, message: "* Obligatorio"

  has_attached_file :prodocumentos, style: {medium: '300x300!',
                                     thumb: '100x100!',
                                     dato: '180x130!',
                                     dato2: '130x130!'}, whiny: false

  validates_attachment_content_type :prodocumentos, content_type: ['application/pdf','image/jpeg','image/png','image/pjpeg'], :message=>"El formato del archivo debe ser (PNG,JPG,JPEG,PDF)"
  validates_attachment_size :prodocumentos, :less_than => 4000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 4 Megabytes"
  validates :prodocumentos, attachment_presence: true, presence: true

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end
end
