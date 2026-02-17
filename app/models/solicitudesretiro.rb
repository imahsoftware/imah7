class Solicitudesretiro < ApplicationRecord
  belongs_to :contrato
  belongs_to :contratosgrupo
  belongs_to :contratospersona
  belongs_to :contratosperfecha
  belongs_to :user

  validates_presence_of :fecha, :justificacion, message: "* Obligatorio"

  has_attached_file :documento_retiro
  validates_attachment_content_type :documento_retiro, content_type: ["application/pdf"]
  validates_attachment_size :documento_retiro, :less_than => 5000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 5 Megabytes"
  validates :documento_retiro, attachment_presence: true, presence: true, on: :create

  def estado
    if user_aprobacion.to_s == ""
      return "PENDIENTE APROBACION"
    elsif user_aprobacion.to_s != "" and user_liquidacion.to_s == ""
      return "APROBADA - PENDIENTE LIQUIDACION"
    elsif user_aprobacion.to_s != "" and user_liquidacion.to_s != ""
      return "APROBADA Y LIQUIDADA"
    end
  end

  validate :validafecha, :on=> :create

  def validafecha
    if fecha.to_s != ""
      obj = Objeto.find_by_sql(["SELECT TIMESTAMPDIFF(DAY, '#{fecha}', curdate()) dias"])[0].dias
      if obj > 2
        errors.add :fecha, "Fecha no habilitada."
      end
    end
    if Solicitudesretiro.where(contratosperfecha_id: self.contratosperfecha_id).present?
      errors.add :justificacion, "Ya existe una solicitud realizada!!!"
      errors.add :fecha, "Ya existe una solicitud realizada!!!"
    end
  end

end
