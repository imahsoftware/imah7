class Personasformulario < ApplicationRecord
  belongs_to :migracionespersona
  belongs_to :parcargo
  belongs_to :municipio
  belongs_to :user
  has_many :personasformulariosdocs, dependent: :destroy
  has_many :personasformulariosmensajes, dependent: :destroy
  has_many :personasformulariosexamenes, dependent: :destroy

  validates_presence_of :talla_conjunto, :talla_zapatos, if: :genero_f?
  validates_presence_of :talla_camisa, :talla_pantalon, :talla_zapatos, if: :genero_m?

  before_save :blanquear_genero

  def valida_tratamiento?
    errors.add :tratamiento_datos, "Debes aceptar el Tratamiento de Datos" if tratamiento_datos == "NO" or tratamiento_datos.blank?
  end

  validates :correo, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i } #, if: :valida_formulario_admin?
  validate :telefono, :celular
  validates :identificacion, uniqueness: { message: "Una persona ya existe con ese documento" }, if: :valida_identificacion?
  validates_numericality_of :identificacion

  def valida_identificacion?
    if minicontratacion.to_s =='SI'
      false
    else
      true
    end
  end

  def valida_total_campos
    if tipo_identificacion.present? and fecha_expedicion.present? and municipio_lugar_expedicion.present? and nombre.present? and primer_apellido.present? and
      genero.present? and orientacion_sexual.present? and tipo_religion.present? and tipo_etnia.present? and madre_cabeza.present? and tipo_vivienda.present? and
      fecha_nacimiento.present? and tipo_sangre.present? and municipio_lugar_nacimiento.present? and direccion.present? and
      municipio_ciudad.present? and telefono.present? and celular.present? and correo.present? and estrato.present? and estado_civil.present? and nivel_educacion.present? and
      nro_hijos.present? and eps.present? and fondo_pension.present? and personas_acargo.present? and contacto_nombre.present? and contacto_telefono.present? and
      victimas.present? and municipio_id.present? and tratamiento_datos.present? and retirado_pension.present? and regimen_excepcion.present? and
      nombre_familiar.present? and ocupacion_familiar.present? and
      empresa_trabaja_familiar.present? and cargo_familiar.present? and direccion_familiar.present? and telefono_familiar.present? and ciudad_familiar.present? and nro_personas_depende_familiar.present? and
      parentesto_familiar.present? and edad_familiar.present? and nombre_padre_familiar.present? and profesion_familiar.present? and telefono_familiar2.present? and nombre_herm_familiar.present? and profesion_herm_familiar.present? and
      telefono_herm_familiar.present? and exp_nombre.present? and exp_direccion.present? and exp_telefono.present? and exp_cargo.present? and exp_nombre_jefe.present? and exp_fecha_ingreso.present? and exp_fecha_retiro.present? and exp_total_servicio.present? and exp_sueldo_inicial.present? and
      exp_sueldo_final.present? and exp_cargo_desempenado.present? and exp_funciones.present? and exp_logros.present? and exp_tipo_contrato.present? and exp_tiempo_contrato.present? and exp_contrato_empresa.present? and exp_contrato_agencia.present? and exp_contrato_otro.present? and
      exp_contrato_cual.present? and ref_nombre1.present? and ref_ocupacion1.present? and ref_direccion1.present? and ref_telefono1.present? and ref_nombre2.present? and ref_ocupacion2.present? and
      ref_direccion2.present? and ref_telefono2.present? and ref_nombre3.present? and ref_ocupacion3.present? and ref_direccion3.present? and ref_telefono3.present? and
      est_primaria_anno_fin.present? and est_primaria_anno_cur.present? and est_primaria_titulo.present? and est_primaria_institucion.present? and est_primaria_ciudad.present? and est_bachiller_tipo.present? and est_bachiller_anno_fin.present? and
      est_bachiller_anno_cur.present? and est_bachiller_titulo.present? and est_bachiller_institucion.present? and est_bachiller_ciudad.present? and tratamiento_datos.present?

      #if tipo_identificacion.present? and fecha_expedicion.present? and municipio_lugar_expedicion.present? and nombre.present? and primer_apellido.present? and
      #genero.present? and fecha_nacimiento.present? and tipo_sangre.present? and municipio_lugar_nacimiento.present? and direccion.present? and
      #municipio_ciudad.present? and telefono.present? and celular.present? and correo.present? and estrato.present? and estado_civil.present? and nivel_educacion.present? and
      #nro_hijos.present? and eps.present? and fondo_pension.present? and personas_acargo.present? and contacto_nombre.present? and contacto_telefono.present? and
      #victimas.present? and tratamiento_datos.present? and retirado_pension.present?
      true
    else
      false
    end
  end

  # Descripcion: Valida Edad En rangos
  validate :validaEdad, if: :valida_formulario_admin?

  def validaEdad
    if fecha_nacimiento.present?
      if calcula_edad.to_i < 16 or calcula_edad.to_i > 75
        errors.add :fecha_nacimiento, "No te encuentras en el rando de edad establecido 16 y 75 Años"
      end
    end
  end

  # Calcula Edad
  def calcula_edad
    now = Time.now.utc.to_date
    now.year - self.fecha_nacimiento.year - ((now.month > self.fecha_nacimiento.month || (now.month == self.fecha_nacimiento.month && now.day >= self.fecha_nacimiento.day)) ? 0 : 1)
  end

  def valida_total_documentos
    valida = []
    self.parcargo.parcargosdocs.where("obligatorio = 'SI'").each do |parcargosdoc|
      if Personasformulariosdoc.where("personasformulario_id = #{self.id} and parcargosdoc_id = #{parcargosdoc.id}").present?
        valida << true
      else
        valida << false
      end
    end
    return !valida.include?(false)
  end

  def valida_encuesta
    if self.parcargo.encuesta_id.present?
      cant = Personasforencuesta.where("personasformulario_id = #{self.id} and encuestaspregunta_id IS NOT NULL
                                      AND encuestapreopcion_id IS NULL").count.to_i
      if cant > 0
        return false
      else
        return true
      end
    else
      return true
    end
  end

  # Descripcion: Metodo para crear los estudiantes en el modulo de usuarios
  # Personasformulario.creacion_estudiantes
  def self.creacion_estudiantes(archivoId)
    error = ""
    Personasformulario.where("archivo_id = #{archivoId} and (status_creausuario is null or status_creausuario not like '* Creado con%')").each do |pp|
      if User.exists?(identificacion: pp.identificacion.to_s.strip) == true
        begin
          error = "* Creado con exito - Identificacion *"
          ActiveRecord::Base.connection.execute("update users set tipoconsulta = 'CANDIDATO', username = '#{pp.identificacion.to_s}',
                                                                      activo = 'S', email = '#{pp.identificacion.to_s + '@asearesp.com'}', personasformulario_id = #{pp.id},
                                                                      etapa = 'A', celular = '#{pp.celular.to_i}', failed_attempts = 0, unlock_token = null, locked_at = null
                                                     where identificacion = '#{pp.identificacion.to_s.strip}'")
        rescue Exception => e
          error = "Error Identificacion"
        end
      elsif User.exists?(["upper(username) = '#{pp.identificacion.to_s.strip}'"]) == true
        begin
          error = "* Creado con exito - Username *"
          ActiveRecord::Base.connection.execute("update users set tipoconsulta = 'CANDIDATO', identificacion = '#{pp.identificacion.to_s}',
                                                                      activo = 'S', email = '#{pp.identificacion.to_s + '@asearesp.com'}', personasformulario_id = #{pp.id},
                                                                      etapa = 'A', celular = '#{pp.celular.to_i}', failed_attempts = 0, unlock_token = null, locked_at = null
                                                   where username = '#{pp.identificacion.to_s.strip}'")
        rescue Exception => e
          error = "Error Username"
        end
      else
        if pp.correo.to_s == ""
          user = User.new
          user.identificacion = pp.identificacion
          user.email = pp.identificacion.to_s + '@asearesp.com'
          user.password = pp.identificacion
          user.nombre = pp.nombre.to_s
          user.nombre_real = pp.nombre.to_s
          user.tipoconsulta = 'CANDIDATO'
          user.portafolio_id = 1
          user.username = pp.identificacion.to_s
          user.activo = 'S'
          user.etapa = 'A'
          user.celular = pp.celular.to_i
          user.personasformulario_id = pp.id
          user.save(validate: false)
          error = "* Creado con exito - sin correo *"
        else
          if User.exists?(["upper(email) = '#{pp.correo.to_s.strip}'"]) == true
            error = error + "El correo ya se encuentra registrados."
          else
            begin
              user = User.new
              user.identificacion = pp.identificacion.to_s
              user.email = pp.correo.to_s
              user.password = pp.identificacion.to_s
              user.nombre = pp.nombre.to_s
              user.nombre_real = pp.nombre
              user.tipoconsulta = 'CANDIDATO'
              user.portafolio_id = 1
              user.username = pp.identificacion.to_s
              user.activo = 'S'
              user.etapa = 'A'
              user.celular = pp.celular.to_i
              user.personasformulario_id = pp.id
              user.save(validate: false)
              error = "* Creado con exito *"
            end
          end
        end
      end
      ActiveRecord::Base.connection.execute("update personasformularios set status_creausuario = '#{error.to_s}' where id = #{pp.id}")
    end
  end

  def self.creacion_minicontratacion(archivoId)
    error = ""
    Personasformulario.where("archivo_id = #{archivoId} and (status_creausuario is null or status_creausuario not like '* Creado con%')").each do |pp|
      if User.exists?(identificacion: pp.identificacion.to_s.strip) == true
        begin
          error = "* Creado con exito - Identificacion *"
          ActiveRecord::Base.connection.execute("update users set tipoconsulta = 'CANDIDATO', activo = 'S', personasformulario_id = #{pp.id}, etapa = 'A',
                                                                      failed_attempts = 0, unlock_token = null, locked_at = null
                                                     where identificacion = '#{pp.identificacion.to_s.strip}'")
        rescue Exception => e
          error = "Error Identificacion"
        end
      elsif User.exists?(["upper(username) = '#{pp.identificacion.to_s.strip}'"]) == true
        begin
          error = "* Creado con exito - Username *"
          ActiveRecord::Base.connection.execute("update users set tipoconsulta = 'CANDIDATO', activo = 'S', personasformulario_id = #{pp.id},
                                                                      etapa = 'A', failed_attempts = 0, unlock_token = null, locked_at = null
                                                   where username = '#{pp.identificacion.to_s.strip}'")
        rescue Exception => e
          error = "Error Username"
        end
      end
      ActiveRecord::Base.connection.execute("update personasformularios set status_creausuario = '#{error.to_s}' where id = #{pp.id}")
    end
  end

  def validateTipo(params)
    @params = params
  end

  def blanquear_genero
    if genero == 'FEMENINO'
      self.talla_pantalon = nil
      self.talla_camisa = nil
    elsif genero == 'MASCULINO'
      self.talla_conjunto = nil
    end

    self.nombre = quita_acento(self.nombre)
    self.primer_apellido = quita_acento(self.primer_apellido)
    self.segundo_apellido = quita_acento(self.segundo_apellido)
    cadena = []
    cadena2 = []
    sqlDatos = ""
    sqlDatos2 = ""
    cadena << self.identificacion.to_s if self.identificacion.to_s != ""
    cadena << self.nombre.to_s if self.nombre.to_s != ""
    cadena2 << self.nombre.to_s if self.nombre.to_s != ""
    cadena << self.primer_apellido.to_s if self.primer_apellido.to_s != ""
    cadena2 << self.primer_apellido.to_s if self.primer_apellido.to_s != ""
    cadena << self.segundo_apellido.to_s if self.segundo_apellido.to_s != ""
    cadena2 << self.segundo_apellido.to_s if self.segundo_apellido.to_s != ""
    if cadena.size.positive?
      sqlDatos << "#{cadena.join(" ")}"
      sqlDatos2 << "#{cadena2.join(" ")}"
    end
    self.autobuscar = sqlDatos
    self.nombre_completo = sqlDatos2
  end

  def valida_formulario_admin?
    if @params != "CANDIDATO"
      false
    else
      true
    end
  end

  def genero_f?
    genero == 'FEMENINO' ? true : false
  end

  def genero_m?
    genero == 'MASCULINO' ? true : false
  end

  def self.search(identificacion, nombre, archivo_id, celular, page, nroreg, user_asignado)
    cadena = []
    cadena << "identificacion = '#{identificacion.to_s}'" if identificacion.present?
    cadena << "UPPER(autobuscar) like '%%#{replacespace(nombre).to_s.upcase.strip}%%'" if nombre.present?
    cadena << "archivo_id = '#{archivo_id.to_s}'" if archivo_id.present?
    cadena << "celular = '#{celular.to_s}'" if celular.present?
    if user_asignado != -1
      cadena << "(user_asignado = #{user_asignado} or user_asignado2 = #{user_asignado} or user_asignado3 = #{user_asignado} or user_asignado4 = #{user_asignado} or user_asignado5 = #{user_asignado})"
    end
    if cadena.size.positive?
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      paginate(page: page, per_page: nroreg).where("#{sqlDatos}").order('created_at desc')
    else
      paginate(page: page, per_page: nroreg).where("id = -1").order('created_at desc')
    end
  end

  def self.replacespace(campo)
    b = campo.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b
  end

  def estado_formulario
    if estado == 'PENDIENTE'
      "<span class='badge bg-light-blue'>Pendiente</span>"
    elsif estado == 'COMPLETADO'
      "<span class='badge bg-yellow'>Completado</span>"
    elsif estado == 'RECHAZADO'
      "<span class='badge bg-red'>Rechazado</span>"
    elsif estado == 'APROBADO'
      "<span class='badge bg-green'>Aprobado</span>"
    elsif estado == 'DESISTE'
      "<span class='badge bg-light-blue'>Desiste</span>"
    elsif estado == 'DEVUELTO'
      "<span class='badge bg-green' style=' background-color: #04C6BB; color: #ffffff;'>Devuelto</span>"
    else
      "<span class='badge bg-green' style=' background-color: #04C6BB; color: #ffffff;'>#{estado.to_s}</span>"
    end
  end

  def valida_estado
    if ['PENDIENTE', 'DEVUELTO'].include?(estado)
      true
    else
      false
    end
  end

=begin
  def autobuscar
    self.nombre = quita_acento(self.nombre)
    self.primer_apellido = quita_acento(self.primer_apellido)
    self.segundo_apellido = quita_acento(self.segundo_apellido)
    cadena = []
    sqlDatos = ""
    cadena << self.identificacion.to_s if self.identificacion.to_s != ""
    cadena << self.nombre.to_s if self.nombre.to_s != ""
    cadena << self.primer_apellido.to_s if self.primer_apellido.to_s != ""
    cadena << self.segundo_apellido.to_s if self.segundo_apellido.to_s != ""
    if cadena.size.positive?
      sqlDatos << "#{cadena.join(" ")}"
    end
    return sqlDatos
  end

  def mombre_completo
    self.nombre = quita_acento(self.nombre)
    self.primer_apellido = quita_acento(self.primer_apellido)
    self.segundo_apellido = quita_acento(self.segundo_apellido)
    cadena = []
    sqlDatos = ""
    cadena << self.nombre.to_s if self.nombre.to_s != ""
    cadena << self.primer_apellido.to_s if self.primer_apellido.to_s != ""
    cadena << self.segundo_apellido.to_s if self.segundo_apellido.to_s != ""
    if cadena.size.positive?
      sqlDatos << "#{cadena.join(" ")}"
    end
    return sqlDatos
  end
=end

  def quita_acento(dato)
    valor = dato.gsub('Á', 'A') rescue nil
    valor = valor.gsub('É', 'E') rescue nil
    valor = valor.gsub('Í', 'I') rescue nil
    valor = valor.gsub('Ó', 'O') rescue nil
    valor = valor.gsub('Ú', 'U') rescue nil
    #valor = valor.gsub('Ñ', 'N') rescue nil
    valor.to_s
  end

  def mensaje_documentos
    if self.personasformulariosdocs.where("estado = 'RECHAZADO'").count.to_i == 1
      "Actualmente cuenta con 1 documento rechazado, por favor corregir y enviar de nuevo."
    elsif self.personasformulariosdocs.where("estado = 'RECHAZADO'").count.to_i > 1
      "Actualmente cuenta con #{self.personasformulariosdocs.where("estado = 'RECHAZADO'").count rescue 0} documentos rechazados, por favor corregirlos y enviar de nuevo. "
    elsif self.personasformulariosdocs.where("estado = 'RECHAZADO'").count.to_i == 0
      "Tu inscripción ha sido a <em>Devuelta</em>, por favor valida tu información. ".html_safe
    end
  end

  def estado_examen_medico
    if self.personasformulariosexamenes.present?
      if self.personasformulariosexamenes.last.estado == "PENDIENTE"
        "<i class='fa fa-calendar-times-o'></i> PENDIENTE".html_safe
      elsif self.personasformulariosexamenes.last.estado == "APROBADO"
        "<i class='fa fa-calendar-check-o'></i> APROBADO".html_safe
      elsif self.personasformulariosexamenes.last.estado == "RECHAZADO"
        "<i class='fa fa-calendar-minus-o'></i> RECHAZADO".html_safe
      end
    else
      "<i class='fa fa-calendar-times-o'></i> NO AGENDADO".html_safe
    end
  end

  def estado_examen_medico_ori
    if self.personasformulariosexamenes.present?
      return self.personasformulariosexamenes.last.estado.to_s rescue nil
    else
      return "NO AGENDADO"
    end
  end

  def validacioncontratocreado
    idPersona = Contratospersona.where("identificacion = '#{self.identificacion}'").first.id rescue nil
    dato = false
    begin
      if Contratosperfecha.where("contratospersona_id = #{idPersona} and estado = 'ACTIVO'").present?
        if Contratosperfecha.where("contratospersona_id = #{idPersona} and estado = 'ACTIVO'").first.codigo_firma.present?
          dato = true
        end
      end
    rescue Exception => e
      logger.error(e.message[0..1999].to_s)
    end
    return dato
  end

end

