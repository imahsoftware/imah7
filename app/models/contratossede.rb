class Contratossede < ApplicationRecord
  belongs_to :contrato
  belongs_to :empresassede
  belongs_to :user
  has_many :contratosprosedes

  #validates_presence_of :empresassede_id, message: "* Obligatorio"

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

  def nombre_consulta
    self.nombre.to_s + ' - (' + self.direccion.to_s + ')'
  end

  def tipos
    cadena = []
    sqlDatos = ""
    if self.clase_aseo.to_s != ""
      cadena << self.clase_aseo.to_s
    end
    if self.clase_aseo2.to_s != ""
      cadena << self.clase_aseo2.to_s
    end
    if self.clase_aseo3.to_s != ""
      cadena << self.clase_aseo3.to_s
    end
    if self.clase_aseo4.to_s != ""
      cadena << self.clase_aseo4.to_s
    end
    if self.clase_aseo5.to_s != ""
      cadena << self.clase_aseo5.to_s
    end
    if cadena.size > 0
      sqlDatos << " #{cadena.join(" - ")}"
    end
    sqlDatos
  end

  def nodos
    cadena = []
    if self.clase_aseo.to_s != ""
      cadena << self.clase_aseo.to_s
    end
    if self.clase_aseo2.to_s != ""
      cadena << self.clase_aseo2.to_s
    end
    if self.clase_aseo3.to_s != ""
      cadena << self.clase_aseo3.to_s
    end
    if self.clase_aseo4.to_s != ""
      cadena << self.clase_aseo4.to_s
    end
    if self.clase_aseo5.to_s != ""
      cadena << self.clase_aseo5.to_s
    end
    cadena
  end

end
