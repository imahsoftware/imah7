class Visitashallazgo < ApplicationRecord
  belongs_to :user
  belongs_to :visita

  validates_presence_of :tipo, :docvisitashallazgo

  has_attached_file :docvisitashallazgo,
                    styles: { medium: '300x300!', thumb: '200x200!', dato: '400x400!', dato2: '500x500!', dato3: '100x100!' },
                    whiny: false
  validates_attachment_content_type :docvisitashallazgo, content_type: /\A*\/.*\Z/
  validates_attachment_size :docvisitashallazgo, :less_than => 15000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 10 Megabytes"

end
