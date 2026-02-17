class Migracion < ApplicationRecord

  has_many :migracionescampos
  has_many :migracionesusers

  def camposselect
    cadena = ""
    self.migracionescampos.order("orden asc").each do |d|
      if cadena == ""
        cadena = d.campo.to_s
      else
        cadena = cadena + ',' + d.campo.to_s
      end
    end
    return cadena.to_s
  end

  def valida
    cadena = ""
    self.migracionescampos.where(valida_formato: 'CARACTERES').order("orden asc").each do |d|
      if cadena == ""
        cadena = d.campo.to_s
      else
        cadena = cadena + ',' + d.campo.to_s
      end
    end
    return cadena.to_s
  end

  def detalle
    if publicado.to_s == 'SI'
      return 'CARGUE'
    elsif publicado.to_s == 'SO'
      return 'SOLICITUD'
    elsif publicado.to_s == 'LI'
      return 'LIQUIDACION'
    elsif publicado.to_s == 'CO'
      return 'CONVOCATORIA'
    elsif publicado.to_s == 'EP'
      return 'EPPS'
    end
  end
end
