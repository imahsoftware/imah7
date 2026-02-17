class Contratosperprodoc < ApplicationRecord
  belongs_to :contratosperproceso
  belongs_to :contratospersona
  belongs_to :user

  validates_presence_of :tipo, :docproceso
  has_attached_file :docproceso
  validates_attachment_content_type :docproceso, content_type: /\A*\/.*\Z/
  validates_attachment_size :docproceso, :less_than => 10000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 10 Megabytes"
end
