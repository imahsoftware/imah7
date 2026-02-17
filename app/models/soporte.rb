class Soporte < ApplicationRecord
  belongs_to :user
  has_many :soportesnotas, dependent: :destroy

  validates_presence_of :tipo, :observacion

  has_attached_file :docsoporte, styles: { medium: '120x120!', thumb: '100x100!' }, whiny: false

  validates_attachment_content_type :docsoporte, content_type: /\A*\/.*\Z/
  validates_attachment_size :docsoporte, less_than: 20000.kilobytes, message: "El tamaño del archivo no puede ser superior a 20 Megabytes"
  do_not_validate_attachment_file_type :docsoporte


  def self.search(nro_ticket, tipo, page, nroreg)
    cadena = []
    if nro_ticket.to_s != ""
      cadena << " id = '#{(nro_ticket.to_s.upcase).to_s.strip}' "
    end
    if tipo.to_s != ""
      cadena << " tipo = '#{(tipo.to_s.upcase).to_s.strip}' "
    end
    if cadena.size > 0
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      paginate(page: page, per_page: nroreg).where("#{sqlDatos}").order('created_at desc')
    else
      paginate(page: page, per_page: nroreg).where("id = -1")
    end
  end

  def mostrar_movil
    if self.user.celular.present? and self.user.celular.to_i > 0
      self.user.celular
    else
      if self.user.identificacion.present?
        if Contratospersona.where("identificacion = '#{self.user.identificacion}'").first.movil.present?
          Contratospersona.where("identificacion = '#{self.user.identificacion}'").first.movil rescue nil
        else
          'Sin Nro Celular Registrado'
        end
      else
        'Sin Nro Celular Registrado'
      end
    end
  end
end
