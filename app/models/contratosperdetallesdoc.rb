class Contratosperdetallesdoc < ApplicationRecord
  belongs_to :contratosperinvdetalle
  belongs_to :user

  validates_presence_of :invdetalle_doc

  has_attached_file :invdetalle_doc, styles: { large: '400x400!', medium: '200x200!', thumb: '100x100!', small: '50x50!' }, whiny: false

  validates_attachment_content_type :invdetalle_doc, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :invdetalle_doc, less_than: 25000.kilobytes, message: "El tamaño del archivo no puede ser superior a 25 Megabytes"
end
