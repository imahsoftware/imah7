class Entrada < ApplicationRecord
  belongs_to :portafolio
  belongs_to :user
  belongs_to :barrio

  validates_presence_of :identificacion,:nombre,:celular,:temperatura,:barrio_id,:clase,:portafolio_id
  validates_numericality_of :identificacion,:celular

  def self.search(nombre,identificacion,fchinicio,fchfin,isportafolio,page,nroreg)
    cadena = []
    if identificacion.to_s != ""
      cadena << " identificacion = '#{(identificacion.to_s.upcase).to_s.strip}' "
    end
    if nombre.to_s != ""
      cadena << " nombre like '%#{nombre.to_s.upcase.strip}%' "
    end
    if fchinicio.to_s != "" and fchfin.to_s != ""
      cadena << " date(created_at) between '#{fchinicio.to_date}' and '#{fchfin.to_date}'"
    end
    if cadena.size > 0
      #cadena << " portafolio_id = #{isportafolio}"
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      #logger.error("sdatos..."+sqlDatos)
      paginate(page: page, per_page: nroreg).where("#{sqlDatos}").order('created_at desc')
    else
      Entrada.where("identificacion = '-1'", nroreg).order('id')
    end
  end
end
