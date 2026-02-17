class Contratosactmcodigosinfo < ApplicationRecord
  belongs_to :contratossede
  belongs_to :user

  def self.search(contratossede_id,nodo,user_id,fchinicio,fchfin,page,nroreg)
    cadena = []
    cadena << " contratossede_id = '#{contratossede_id.to_s}' " if contratossede_id.to_s != ""
    cadena << " nodo = '#{nodo.to_s}' " if nodo.to_s != ""
    cadena << " user_id = '#{user_id.to_s}' " if user_id.to_s != ""
    cadena << " fecha between '#{fchinicio.to_date}' and '#{fchfin.to_date}'" if fchinicio.to_s != "" and fchfin.to_s != ""
    if cadena.size.positive?
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      paginate(page: page, per_page: nroreg).where("#{sqlDatos}").order('fecha desc')
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
end
