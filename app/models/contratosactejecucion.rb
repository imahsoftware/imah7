class Contratosactejecucion < ApplicationRecord
  belongs_to :contratosactividad
  belongs_to :contratossede
  belongs_to :contratosnodo
  belongs_to :user

  validates_presence_of :nota, if: :is_norealizada

  def is_norealizada
    if self.realizada.to_s == 'NO'
      true
    else
      false
    end
  end

  def self.search(contratosactividad_id,contratossede_id,user_id,fchinicio,fchfin,realizada,clase,page,nroreg)
    cadena = []
    cadena << " contratosactejecuciones.contratosactividad_id = '#{contratosactividad_id.to_s}' " if contratosactividad_id.to_s != ""
    cadena << " contratosactejecuciones.contratossede_id = '#{contratossede_id.to_s}' " if contratossede_id.to_s != ""
    cadena << " contratosactejecuciones.user_id = '#{user_id.to_s}' " if user_id.to_s != ""
    cadena << " date_format(contratosactejecuciones.created_at,'%Y-%m-%d') between '#{fchinicio.to_date}' and '#{fchfin.to_date}'" if fchinicio.to_s != "" and fchfin.to_s != ""
    cadena << " contratosactejecuciones.realizada = '#{realizada.to_s}' " if realizada.to_s != ""
    cadena << " contratosactejecuciones.contratosactividad_id in (select id from contratosactividades where clase = '#{clase.to_s}') " if clase.to_s != ""
    if cadena.size.positive?
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      paginate(page: page, per_page: nroreg).select("contratossedes.nombre sedenombre, users.nombre usernombre, contratosactividades.clase,contratosactividades.tipo,contratosactividades.turno,contratosactividades.horario,contratosactividades.detalle,contratosactejecuciones.* ")
                                            .where("#{sqlDatos}").order('contratosactejecuciones.created_at desc')
    else
      paginate(page: page, per_page: nroreg).select("contratossedes.nombre sedenombre, users.nombre usernombre, contratosactividades.clase,contratosactividades.tipo,contratosactividades.turno,contratosactividades.horario,contratosactividades.detalle,contratosactejecuciones.* ")
                                            .where("contratosactejecuciones.id = '-1'").order('contratosactejecuciones.id')
    end
  end
end
