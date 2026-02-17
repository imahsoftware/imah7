class Veriserviciosasoporte < ApplicationRecord
  belongs_to :veriserviciosagenda
  belongs_to :user

  validates_presence_of :descripcion, :verisoporte

  has_attached_file :verisoporte,
                    styles: { medium: '300x300!', thumb: '200x200!', dato: '400x400!', dato2: '500x500!', dato3: '100x100!' },
                    whiny: false
  validates_attachment_content_type :verisoporte, content_type: /\A*\/.*\Z/
  validates_attachment_size :verisoporte, :less_than => 15000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 10 Megabytes"
end
