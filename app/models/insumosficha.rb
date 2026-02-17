class Insumosficha < ApplicationRecord
  belongs_to :insumo
  belongs_to :user

  validates_presence_of :marca, :referencia, :docficha, :estado, :fecha_version, :fecha_vencimiento

  has_attached_file :docficha,
                    styles: { medium: '300x300!', thumb: '200x200!', dato: '400x400!', dato2: '500x500!', dato3: '100x100!' },
                    whiny: false
  validates_attachment_content_type :docficha, content_type: /\A*\/.*\Z/
  validates_attachment_size :docficha, :less_than => 15000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 10 Megabytes"
end
