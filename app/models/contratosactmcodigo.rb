class Contratosactmcodigo < ApplicationRecord
  belongs_to :contratossede
  belongs_to :user
  belongs_to :tiposmevaluacion

  validates_presence_of :calificacion, message: "* Obligatorio"

  def self.search(contratossede_id,nodo,user_id,fchinicio,fchfin,page,nroreg)
    cadena = []
    cadena << " contratossede_id = '#{contratossede_id.to_s}' " if contratossede_id.to_s != ""
    cadena << " nodo = '#{nodo.to_s}' " if nodo.to_s != ""
    cadena << " user_id = '#{user_id.to_s}' " if user_id.to_s != ""
    cadena << " date(created_at) between '#{fchinicio.to_date}' and '#{fchfin.to_date}'" if fchinicio.to_s != "" and fchfin.to_s != ""
    if cadena.size.positive?
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      paginate(page: page, per_page: nroreg).where("#{sqlDatos}").order('id asc')
    else
      paginate(page: page, per_page: nroreg).where("id = '-1'").order('id')
    end
  end

  def sedenombre
    contratossede.nombre rescue nil
  end
  def usernombre
    user.nombre rescue nil
  end
  def tiposmevaluaciondesc
    tiposmevaluacion.descripcion rescue nil
  end
  def tiposmevaluaciondetalle
    tiposmevaluacion.detalle rescue nil
  end
  def createdat
    created_at.strftime("%Y-%m-%d").to_s
  end
end
