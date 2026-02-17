class Contratosperfechasdoc < ApplicationRecord
  validates_presence_of :descripcion

  has_attached_file :soporte_digital
  validates_attachment_content_type :soporte_digital, content_type: ["image/jpg","image/jpeg", "image/png", "application/pdf"]

end
