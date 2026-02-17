class Personasformulariosdoc < ApplicationRecord
  belongs_to :parcargosdoc
  belongs_to :parcargo
  belongs_to :personasformulario

  has_attached_file :soporte_digital, style: {medium: '300x300!',
                                        thumb: '100x100!',
                                        dato: '180x130!',
                                        dato2: '130x130!'}, whiny: false

  #validates_attachment_content_type :soporte_digital, content_type: ['application/pdf','image/jpeg','image/png','image/pjpeg'], :message=>"El formato del archivo debe ser (PNG,JPG,JPEG,PDF)", if: :imagen
  validates_attachment_content_type :soporte_digital, content_type: ['image/jpeg','image/png','image/pjpeg'], :message=>"El formato del archivo debe ser (PNG,JPG,JPEG)", if: :imagen
  validates_attachment_content_type :soporte_digital, content_type: ['application/pdf'], :message=>"El formato del archivo debe ser (PDF)", if: :pdf
  validates_attachment_size :soporte_digital, :less_than => 5000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 5 Megabytes"
  validates :soporte_digital, attachment_presence: true, presence: true
  validate :validarechazo
  #before_save :antesdeguardar

  def imagen
    self.parcargosdoc.soloimagen.to_s == 'SI'
  end

  def pdf
    self.parcargosdoc.soloimagen.to_s == 'NO'
  end
=begin
  def antesdeguardar
    puts "-------"
    puts ".imagen.." + self.soporte_digital_content_type.to_s
    puts ".cargo.." + self.parcargosdoc.soloimagen.to_s
    puts "-------"
    if self.parcargosdoc.soloimagen.to_s == 'SI'
      puts ".ingresop1111..."
      if ['image/jpeg','image/png','image/pjpeg'].exclude?(self.soporte_digital_content_type.to_s)
          puts ".ingresop..."
          errors.add :soporte_digital, "Este documento solo puede ser una IMAGEN"
          errors.add :soporte_digital, "Este documento solo puede ser una IMAGEN"
          errors.add :soporte_digital, "Este documento solo puede ser una IMAGEN"
          errors.add :soporte_digital, "Este documento solo puede ser una IMAGEN"
          errors.add :observacion, "Debes indicar la observacion del rechazo"
      end
    end
  end
=end

  def validarechazo
    if self.estado.to_s == 'RECHAZADO' and self.observacion.to_s == ""
      errors.add :observacion, "Debes indicar la observacion del rechazo"
    end
  end

  def estado_documento
    if estado == 'PENDIENTE'
      "<span class='badge bg-yellow'>Pendiente</span>"
    elsif estado == 'RECHAZADO'
      "<span class='badge bg-red'>Rechazado</span>"
    elsif estado == 'APROBADO'
      "<span class='badge bg-green'>Aprobado</span>"
    end
  end

  def valida_estado_doc
    if ['PENDIENTE', 'RECHAZADO'].include?(estado)
      true
    else
      false
    end
  end
end
