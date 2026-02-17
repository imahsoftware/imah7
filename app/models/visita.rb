class Visita < ApplicationRecord

  belongs_to :user
  belongs_to :contrato
  has_many :visitasnotas, dependent: :destroy
  has_many :visitascompromisos, dependent: :destroy
  has_many :visitasdocs, dependent: :destroy
  has_many :visitassedes, dependent: :destroy
  has_many :visitasatenciones, dependent: :destroy
  has_many :visitashallazgos, dependent: :destroy
  has_many :visitasasistentes, dependent: :destroy


  has_attached_file :doc_georeferenciacion,
                    styles: { medium: '300x300!', thumb: '200x200!', dato: '400x400!', dato2: '500x500!', dato3: '100x100!' },
                    whiny: false
  validates_attachment_content_type :doc_georeferenciacion, content_type: /\A*\/.*\Z/
  validates_attachment_size :doc_georeferenciacion, :less_than => 15000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 10 Megabytes"

  validates_presence_of :descripcion, :latitude, :contrato_id

  def descripcion_visita
    "<b>Usuario:</b> #{user.nombre} - <b>Fecha:</b> #{created_at.strftime("%d/%m/%Y %X")} - <b>Dirección:</b> #{direccion} - <b>Latitud:</b> #{latitude} - <b>Longitud:</b> #{longitude}".html_safe rescue nil
  end

  def descripcion_visitafin
    "<b>Usuario:</b> #{user.nombre} - <b>Fecha:</b> #{finalizacion.strftime("%d/%m/%Y %X")} - <b>Dirección:</b> #{fin_direccion} - <b>Latitud:</b> #{fin_latitude} - <b>Longitud:</b> #{fin_longitude}".html_safe rescue nil
  end

  def self.search (clase, userConsulta, user_id, contrato_id, fchinicial, fchfinal, page, format)
    usersconsulta = User.find(userConsulta)
    data = false
    if usersconsulta.usersvisitas.present?
      data = true
    end
    cadena = []
    cadena << "user_id = '#{user_id}'" if user_id.to_s != ""
    cadena << "teletrabajo = '#{clase}'" if clase.to_s != ""
    if data
      cadena << "contrato_id = '#{contrato_id}' and user_id in (select user_asignado from usersvisitas where user_id = #{userConsulta})" if contrato_id.to_s != ""
      cadena << " user_id in (select user_asignado from usersvisitas where user_id = #{userConsulta}) and date(created_at) between '#{fchinicial.to_date}' and '#{fchfinal.to_date}'" if fchinicial.to_s != "" and fchfinal.to_s != ""
    else
      cadena << "contrato_id = '#{contrato_id}'" if contrato_id.to_s != ""
      cadena << " date(created_at) between '#{fchinicial.to_date}' and '#{fchfinal.to_date}'" if fchinicial.to_s != "" and fchfinal.to_s != ""
    end
    # cadena << "DATE_FORMAT(created_at, '%Y-%m-%d') between " + "'#{fchinicial.to_s}'" + " and " + "'#{fchfinal.to_s}'" if fchinicial.to_s != "" and fchfinal.to_s != ""
    if cadena.size.positive?
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      where("#{sqlDatos}").order("created_at desc")
    else
      where('created_at = now()').order("created_at desc")
    end
  end

  def mensaje_faltante

    dato = "Hola, Te falta registrar: "
    messages = []
    supernumerario = ""
    if self.user.tipoconsulta == 'SUPERNUMERARIO'
      supernumerario = 'SI'
    end
    objetoid = Objeto.find_by_descripcion("excepcioncierrevisita").id rescue 0
    exceptionFirma =  Userspermiso.exists?(["user_id = ? and objeto_id = ? and crea = 'S'", self.user_id, objetoid])

    if supernumerario == ""
      unless visitasnotas.present?
        messages << "notas "
      end
      #unless visitascompromisos.present?
      # messages << "compromisos"
      #end
      if Contratossede.where("contrato_id = #{contrato_id}").present?
        unless visitassedes.present?
          messages << "sedes"
        end
      end
    end
    if exceptionFirma == false
      if visitasdocs.where("tipo = 'DESPUES'").blank? && !visitasatenciones.where("codigo_firma is not null").present?
        messages << "firma digital de quien recibe la visita"
      end
    end
    if messages.present?
      dato = "<b class='text-red'>" + dato + messages.join(', ') + "</b>"
    end
  end
end
