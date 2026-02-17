class Contratosentepp < ApplicationRecord
  belongs_to :contrato
  belongs_to :user
  belongs_to :contratosperfecha
  belongs_to :contratospersona

  has_many :contratosenteppsdetalles, dependent: :destroy
  has_many :contratosenteppsfirmas, dependent: :destroy

  validates_presence_of :contrato_id

  def self.searchInforme(autobuscar, page, nroreg)
    cadena = []
    if autobuscar.to_s != ""
      cadena << " contrato_id in (select id from contratos where concate(nro_contrato, '- ', objeto) like '%%#{autobuscar.to_s.upcase.strip}%%') "
    end
    if cadena.size > 0
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      paginate(page: page, per_page: nroreg).where("#{sqlDatos}").order('created_at desc')
    else
      paginate(page: page, per_page: nroreg).where("id = -1")
    end
  end

end
