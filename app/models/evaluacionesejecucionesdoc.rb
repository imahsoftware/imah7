class Evaluacionesejecucionesdoc < ApplicationRecord
  belongs_to :evaluacionesejecucion
  belongs_to :user

  validates_presence_of :tipo, :docevaluacion

  has_attached_file :docevaluacion, styles: { medium: '120x120!', thumb: '100x100!', large: '500x500!' }, whiny: false

  validates_attachment_content_type :docevaluacion, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :docevaluacion, less_than: 15000.kilobytes, message: "El tamaño del archivo no puede ser superior a 10 Megabytes"
end
