class Visitasdoc < ApplicationRecord

  belongs_to :user
  belongs_to :visita

  validates_presence_of :tipo, :docvisita

  has_attached_file :docvisita,
                    styles: { medium: '300x300!', thumb: '200x200!', dato: '400x400!', dato2: '500x500!', dato3: '100x100!' },
                    whiny: false
  validates_attachment_content_type :docvisita, content_type: /\A*\/.*\Z/
  validates_attachment_size :docvisita, :less_than => 15000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 10 Megabytes"


  def tipo_descripcion
    if tipo == 'ANTES'
      return 'FOTO INICIO'
    elsif tipo == 'DESPUES'
      return 'FOTO FINALIZACIÓN'
    else
      tipo
    end
  end
end
