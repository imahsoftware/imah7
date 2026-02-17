class Contratosactividad < ApplicationRecord
  belongs_to :contrato
  belongs_to :user
  belongs_to :contratossede
  has_many :contratosactejecuciones
  has_many :contratosactnotas

  validates_presence_of :detalle,:clase,:tipo, message: "* Obligatorio"
  validates_presence_of :contratossede_id, :dia_semana, if: :is_fuerte, message: "* Obligatorio"

  def is_fuerte
    if self.tipo.to_s == 'ASEO FUERTE'
      true
    else
      false
    end
  end

  def nombrelista
    self.detalle.to_s + ' (' + self.clase.to_s + ' - ' + self.tipo.to_s + ')' rescue nil
  end

  def self.search(detalle,contratossede_id,tipo,clase,dia_semana,page,nroreg)
    cadena = []
    cadena << "upper(detalle) like '%%#{replacespace(detalle).to_s.upcase.strip}%%'" if detalle.to_s != ""
    cadena << "contratossede_id = '#{contratossede_id.to_s}'" if contratossede_id.to_s != ""
    cadena << "tipo = '#{tipo.to_s}'" if tipo.to_s != ""
    cadena << "clase = '#{clase.to_s}'" if clase.to_s != ""
    cadena << "dia_semana = '#{dia_semana.to_s}'" if dia_semana.to_s != ""
    if cadena.size.positive?
      cadena << "contrato_id = 97"
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      paginate(page: page, per_page: nroreg).where("#{sqlDatos}").order('created_at desc')
    else
      paginate(page: page, per_page: nroreg).where("id = -1").order('created_at desc')
    end
  end

  def self.replacespace(campo)
    b = campo.sub(" ","%%")
    b = b.sub(" ","%%")
    b = b.sub(" ","%%")
    b = b.sub(" ","%%")
    b
  end

  def existeactejecutada(nodo,isadmin)
    if Contratosactejecucion.where(["contratosnodo_id = #{nodo} and contratosactividad_id = #{self.id} and user_id = #{isadmin} and date(created_at) = curdate()"]).exists?
      "<i class='fa fa-adn text-red'></i>".html_safe
    end
  end
end
