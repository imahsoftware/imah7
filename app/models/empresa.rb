class Empresa < ApplicationRecord
  belongs_to :tiposdocumento
  belongs_to :municipio
  belongs_to :user
  has_many :contratos
  has_many :empresassedes

  validates_presence_of :identificacion, :nombre, message: "* Obligatorio"

  after_save :despuesdeguardar

  def despuesdeguardar
    ActiveRecord::Base.connection.execute("UPDATE empresas SET autobuscar = REPLACE(CONCAT(IFNULL(identificacion,''),'-',IFNULL(digito,''),' ',IFNULL(nombre,'')),'  ',' ')
                                           where id = #{self.id}")
  end

  def self.searchInforme(autobuscar,page,nroreg)
    cadena = []
    if autobuscar.to_s != ""
      cadena << " autobuscar like '%%#{autobuscar.to_s.upcase.strip}%%' "
    end
    if cadena.size > 0
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      paginate(page: page, per_page: nroreg).where("#{sqlDatos}").order('created_at desc')
    else
      paginate(page: page, per_page: nroreg).where("id = -1")
    end
  end

  def self.searchInformeEpps(autobuscar,page,nroreg)
    cadena = []
    if autobuscar.to_s != ""
      cadena << " autobuscar like '%%#{autobuscar.to_s.upcase.strip}%%' and id in (select empresa_id from contratos where id in (select contrato_id from contratosentepps))"
    end
    if cadena.size > 0
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      paginate(page: page, per_page: nroreg).where("#{sqlDatos}").order('created_at desc')
    else
      paginate(page: page, per_page: nroreg).where("id = -1")
    end
  end

  def self.search(identificacion,nombre,page,nroreg,prefactura,recibo)
    cadena = []
    if identificacion.to_s != ""
      cadena << " identificacion = '#{(identificacion.to_s.upcase).to_s.strip}' "
    end
    if nombre.to_s != ""
      cadena << " nombre like '%%#{nombre.to_s.upcase.strip}%%' "
    end
    if prefactura.to_s != ""
      cadena << " id in (select c.empresa_id
                         from contratos c, contratosprefacturas f
                         where f.id = #{prefactura}
                         and   f.contrato_id = c.id) "
    end
    if recibo.to_s != ""
      cadena << " id in (select c.empresa_id
                         from contratos c, contratospagos f
                         where f.consecutivo = '#{recibo}'
                         and   f.contrato_id = c.id) "
    end
    if cadena.size > 0
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      paginate(page: page, per_page: nroreg).where("#{sqlDatos}").order('created_at desc')
    else
      paginate(page: page, per_page: nroreg).where("id = -1")
    end
  end

  def identnombre
    identificacion.to_s + '-' + digito.to_s + ' ' + nombre.to_s rescue nil
  end

  def identdigito
    identificacion.to_s + '-' + digito.to_s rescue nil
  end

  def idportafolio
    return portafolio_id.to_i
=begin
    if logo.to_s == 'logo_inicio_asear.png'
      return 1
    elsif logo.to_s == 'microcinco.jpg'
      return 2
    elsif logo.to_s == 'construmater.jpg'
      return 3
    elsif logo.to_s == 'julian.jpg'
      return 4
    elsif logo.to_s == 'aseartemporal.jpg'
      return 5
    elsif logo.to_s == 'progescol.jpg'
      return 6
    end
=end
  end



end
