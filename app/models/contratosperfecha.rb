class Contratosperfecha < ApplicationRecord
  audited
  include InformationConcern

  belongs_to :contrato
  belongs_to :user
  belongs_to :contratospersona
  belongs_to :contratoscargo
  belongs_to :contratosgrupo
  belongs_to :contratosseccion
  has_many :contratosperliquidaciones
  has_many :contratospervacaciones
  has_many :contratospernominas
  has_many :contratosperfechasdocs
  has_many :contratospernotas
  has_many :contratosperprocesos

  validates_presence_of :fecha_inicio, :contratoscargo_id, :contratosgrupo_id,:tipo_contrato, :estado, message: "* Obligatorio"

  validate :validafecha

  def validafecha
    if fecha_inicio.to_s != "" and fecha_fin.to_s != ""
      if fecha_fin < fecha_inicio
        errors.add :fecha_fin, "La fecha fin no puede ser inferior a la fecha de inicio."
      end
    end
    if contratosseccion_id.to_s != "" and contratosseccion_id.to_i > 0
      if self.id
        ffseccion = Contratosperfecha.find(self.id)
        if ffseccion.contratosseccion_id.to_s != contratosseccion_id.to_s
          cantidad = Contratosseccion.find(contratosseccion_id).cantidad.to_i rescue 0
          cantContratos = Contratosperfecha.where("contratosseccion_id = #{contratosseccion_id} and (fecha_fin is null or fecha_fin > now()) ").count.to_i rescue 0
          cantContratos = cantContratos + 1
          if cantidad > 0 and cantContratos > cantidad
            errors.add :contratosseccion_id, "* Esta seccion no tiene cupo"
            errors.add :contratoscargo_id, "* Esta seccion no tiene cupo"
            errors.add :contratosgrupo_id, "* Esta seccion no tiene cupo"
          end
        end
      else
        cantidad = Contratosseccion.find(contratosseccion_id).cantidad.to_i rescue 0
        cantContratos = Contratosperfecha.where("contratosseccion_id = #{contratosseccion_id} and (fecha_fin is null or fecha_fin > now()) ").count.to_i rescue 0
        cantContratos = cantContratos + 1
        if cantidad > 0 and cantContratos > cantidad
          errors.add :contratosseccion_id, "* Esta seccion no tiene cupo"
          errors.add :contratoscargo_id, "* Esta seccion no tiene cupo"
          errors.add :contratosgrupo_id, "* Esta seccion no tiene cupo"
        end
      end
    end
    if contratoscargo_id.to_s != "" and contratoscargo_id.to_i > 0 and self.id.blank?
      cantidad = Contratoscargo.find(contratoscargo_id).disponibles.to_i rescue 0
      #cantContratos = Contratosperfecha.where("contratoscargo_id = #{contratoscargo_id} and (fecha_fin is null or fecha_fin > now()) ").count.to_i rescue 0
      cantidad = cantidad - 1
      if cantidad < 0
        errors.add :contratoscargo_id, "* Este grupo de nomina no tiene cupo"
        errors.add :contratosgrupo_id, "* Este grupo de nomina no tiene cupo"
      end
    end
    if contratosgrupo_id.to_s == "0"
      errors.add :contratosgrupo_id, "* Obligatorio"
    end
    if contratoscargo_id.to_s == "0"
      errors.add :contratoscargo_id, "* Obligatorio"
    end
    # 2024-02-02 Validacion de Duplicacion de Informacion
    if self.id.blank?
      if contratospersona_id.present? and contrato_id.present? and contratoscargo_id.present? and contratosgrupo_id.present? and fecha_inicio.present?
        if Contratosperfecha.where(contratospersona_id: contratospersona_id, contrato_id: contrato_id, contratoscargo_id: contratoscargo_id, contratosgrupo_id:contratosgrupo_id, fecha_inicio: fecha_inicio).present?
          errors.add :contrato_id, "* Duplicado"
          errors.add :contratoscargo_id, "* Duplicado"
          errors.add :contratosgrupo_id, "* Duplicado"
          errors.add :fecha_inicio, "* Duplicado"
        end
      end
    end
  end

  def detallecontrato
    cadena = []
    cadena << self.contrato.empresa.identnombre.to_s rescue nil
    cadena << self.contrato.nro_contrato.to_s rescue nil
    cadena << self.contratoscargo.perfil.to_s rescue nil
    sqlDatos = ""
    if cadena.size.positive?
      sqlDatos << "#{cadena.join(" - ")}"
    end
    #puts sqlDatos
    return sqlDatos
  end

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

  def salariofinal
    if salario.to_i > 0
      return salario.to_f rescue 0
    else
      return self.contratoscargo.salario.to_f rescue 0
    end
  end

  def estado_dotacion
    if val_dotacion == 'PENDIENTE'
      "<i class='fa fa-close' style='color: red;'></i> ".html_safe
    else
      "<i class='fa fa-check' style='color: green;'></i> ".html_safe
    end
  end

  def estado_carnet
    if val_carne == 'PENDIENTE'
      "<i class='fa fa-close' style='color: red;'></i> ".html_safe
    else
      "<i class='fa fa-check' style='color: green;'></i> ".html_safe
    end
  end

  def estado_eps
    if val_eps == 'PENDIENTE'
      "<i class='fa fa-close' style='color: red;'></i> ".html_safe
    else
      "<i class='fa fa-check' style='color: green;'></i> ".html_safe
    end
  end

  def estado_afp
    if val_afp == 'PENDIENTE'
      "<i class='fa fa-close' style='color: red;'></i> ".html_safe
    else
      "<i class='fa fa-check' style='color: green;'></i> ".html_safe
    end
  end

  def estado_arl
    if val_arl == 'PENDIENTE'
      "<i class='fa fa-close' style='color: red;'></i> ".html_safe
    else
      "<i class='fa fa-check' style='color: green;'></i> ".html_safe
    end
  end

  def nombrelista
    cadena = []
    cadena << 'Empresa: ' + self.contrato.empresa.identnombre.to_s
    cadena << 'Nro Contrato: ' + self.contrato.nro_contrato.to_s
    cadena << 'Cargo: ' + self.contratoscargo.perfil.to_s
    sqlDatos = ""
    if cadena.size.positive?
      sqlDatos << "#{cadena.join(" - ")}"
    end
    return sqlDatos
  end

  def fechascontrato
    if self.fecha_fin.to_s == ""
      return self.fecha_inicio.strftime("%Y-%m-%d").to_s rescue nil
    else
      return self.fecha_inicio.strftime("%Y-%m-%d").to_s + ' - ' + self.fecha_fin.strftime("%Y-%m-%d").to_s rescue nil
    end
  end

end
