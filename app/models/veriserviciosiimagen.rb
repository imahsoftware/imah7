class Veriserviciosiimagen < ApplicationRecord
  belongs_to :veriserviciositem
  belongs_to :user

  validates_presence_of :descripcion, :veriimagen

  has_attached_file :veriimagen,
                    styles: { medium: '300x300!', thumb: '200x200!', dato: '400x400!', dato2: '500x500!', dato3: '100x100!' },
                    whiny: false
  validates_attachment_content_type :veriimagen, content_type: /\A*\/.*\Z/
  validates_attachment_size :veriimagen, :less_than => 15000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 10 Megabytes"

end
