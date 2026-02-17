class Tareasactividad < ApplicationRecord
  audited
  belongs_to :tarea
  belongs_to :iparametro
  belongs_to :user
  has_many :tareasactdocs, :dependent => :destroy

  validates_presence_of  :descripcion, :user_persona, :dias

  def estado_descripcion
    if estado.to_s == '0'
      "PENDIENTE"
    elsif estado.to_s == '0.5'
      'EN PROCESO'
    elsif estado.to_s == '1'
      'COMPLETADO'
    elsif estado.to_s == '1.0'
      'NO APLICA'
    end
  end

  def estado_color
    if self.estado.to_s == '0'
      "rojo_semaforo.png"
    elsif self.estado.to_s == '0.5'
      "azul_semaforo.png"
    elsif self.estado.to_s == '1'
      "verde_semaforo.png"
    elsif self.estado.to_s == '1.0'
      "azul_semaforo.png"
    end
  end

  def boton_estado
    if self.estado.to_s == '0'
      "danger"
    elsif self.estado.to_s == '0.5'
      "warning"
    elsif self.estado.to_s == '1'
      "success"
    elsif self.estado.to_s == '1.0'
      "info"
    end
  end

  def fechalimite_color
    if self.estado.to_s != '0'
      if updated_at.to_date <= fecha_limite.to_date
        return 'text-green'
      elsif  updated_at.to_date > fecha_limite.to_date
        return 'text-red'
      end
    end
  end

  def updatedat
    if created_at != updated_at
      return 'Ult. Act: ' + updated_at.strftime("%Y-%m-%d %X").to_s rescue nil
    end
  end
=begin
  #validates_presence_of :dias, if: :valida_dias?

  #def valida_dias?
  #  self.tarea.fecha_adjudicacion.present? ? true : false
  #end

  #before_save :antesdeguardar

  def antesdeguardar
    ActiveRecord::Base.connection.execute("CALL prc_duplicar_tarea(#{self.id},'R')")
    #if self.tarea.fecha_adjudicacion.present? # Verifica si la fecha de adjudicación de la tarea está presente
    #  self.fecha_limite = self.tarea.fecha_adjudicacion + dias # Suma la variable 'dias' a la fecha de adjudicación y asigna el resultado a 'fecha_limite'
    #end
  end
=end

end
