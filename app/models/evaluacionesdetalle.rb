class Evaluacionesdetalle < ApplicationRecord
  belongs_to :evaluacion
  belongs_to :user

  validates_presence_of :clase, :actividad, :requieredoc

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

  def actividadesnombre
    dato = ""
    Iparametrosuser.select("(select nombre from users where id = iparametrosusers.user_id) nombreusuario")
                   .where("iparametro_id in (select id from iparametros where campo = 'evaluacion_clase' and descripcion = '#{clase}')").each do |a|
      dato = dato + '* ' + a.nombreusuario.to_s + '<br/>'
    end
    return dato
  end

  def actividadesnombreperiodo
    dato = ""
    Iparametrosuser.select("(select nombre from users where id = iparametrosusers.user_id) nombreusuario")
                   .where("iparametro_id in (select id from iparametros where campo = 'evaluacion_clase_prueba' and descripcion = '#{clase}')").each do |a|
      dato = dato + '* ' + a.nombreusuario.to_s + '<br/>'
    end
    return dato
  end
end
