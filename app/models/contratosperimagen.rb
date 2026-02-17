class Contratosperimagen < ApplicationRecord
  belongs_to :contratospersona
  belongs_to :contratosperfecha
  belongs_to :user

  validates_presence_of :descripcion,:observacion_documento, message: "* Obligatorio"

  has_attached_file :personasimagen, style: {medium: '300x300!',
                                     thumb: '100x100!',
                                     dato: '180x130!',
                                     dato2: '130x130!'}, whiny: false
  validates_attachment_content_type :personasimagen, content_type: ['application/pdf'], :message=>"El formato del archivo debe ser (PDF)"
  validates_attachment_size :personasimagen, :less_than => 20000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 20 Megabytes"
  validates :personasimagen, attachment_presence: true, presence: true

  validate :valida_contrato?

  def valida_contrato?
    if Contratosperfecha.where(contratospersona_id: self.contratospersona_id).present? and contratosperfecha_id.to_s == ""
      errors.add :contratosperfecha_id, "Debes asociar el contrato"
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end
end
