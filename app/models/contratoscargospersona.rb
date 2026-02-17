class Contratoscargospersona < ApplicationRecord
  belongs_to :contratoscargo
  belongs_to :user

  validates_presence_of :identificacion,:nombre,:primer_apellido,:segundo_apellido,:celular,:correo,:municipio_id,:recomendado_por,:observacion, message: "* Obligatorio"

  has_attached_file :cargoimagen
  validates_attachment_content_type :cargoimagen, content_type: ["application/vnd.ms-outlook; charset=binary","application/x-ole-storage","image/jpeg", "image/gif", "image/png", "application/pdf"]
  validates_attachment_size :cargoimagen, :less_than => 5000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 5 Megabytes"

end
