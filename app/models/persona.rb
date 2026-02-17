class Persona < ApplicationRecord
  has_many :users
  has_many :personasobservaciones
  has_many :personasimagenes
  has_many :portafolios

  validates :identificacion, uniqueness: {scope: :portafolio_id, message: "Una persona ya existe con ese documento"}

  def nombreportafolio
    if self.portafolio_id == 1
      'ASEAR S.A. E.S.P'
    elsif self.portafolio_id == 2
      'MICROCINCO'
    elsif self.portafolio_id == 3
      'CONSTRUMATER'
    end
  end

  def self.search(nombre,identificacion,page,nroreg)
    cadena = []
    if identificacion.to_s != ""
      cadena << " identificacion = '#{(identificacion.to_s.upcase).to_s.strip}' "
    end
    if nombre.to_s != ""
      cadena << " nombre like '%%#{replacespace(nombre.to_s.upcase.strip)}%%' "
    end
    if cadena.size > 0
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      paginate(page: page, per_page: nroreg).where("#{sqlDatos}").order('created_at desc')
    else
      Persona.where("identificacion = '-1'", nroreg).order('id')
    end
  end

  def centrodetrabajo
    vlr = Centro.find(Antecedente.find_by_persona_id(self.id).centro_id).descripcion rescue nil
    if vlr
      ' (' + vlr.to_s + ')'
    else
      nil
    end
  end

  def self.replacespace(campo)
    b = campo.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b
  end
end
