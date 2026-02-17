class Contratosinsimagen < ApplicationRecord
  belongs_to :contratosinsumo
  belongs_to :user

  validates :insumosimagen, attachment_presence: true

  has_attached_file :insumosimagen
  validates_attachment_content_type :insumosimagen, content_type: /\Aimage\/.*\z/
  validates_attachment_size :insumosimagen, :less_than => 5000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 5 Megabytes"

end
