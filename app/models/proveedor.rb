class Proveedor < ApplicationRecord
  belongs_to :municipio
  belongs_to :user
  has_many :proveedorescontactos
  has_many :proveedoresimagenes

  validates_presence_of :identificacion, :nombre_proveedor, message: "* Obligatorio"

  def self.search(identificacion,nombre,page,nroreg)
    cadena = []
    if identificacion.to_s != ""
      cadena << " identificacion = '#{(identificacion.to_s.upcase).to_s.strip}' "
    end
    if nombre.to_s != ""
      cadena << " nombre_proveedor like '%%#{nombre.to_s.upcase.strip}%%' "
    end
    if cadena.size > 0
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      paginate(page: page, per_page: nroreg).where("#{sqlDatos}").order('created_at desc')
    else
      Proveedor.where("identificacion = '-1'", nroreg).order('id')
    end
  end


end
