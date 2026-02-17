class Periodosliquidacion < ApplicationRecord

  validates_presence_of :inicio, :fin, :estado, message: "* Obligatorio"

  def destado
    if estado == 'P'
      return 'PENDIENTE'
    elsif estado == 'C'
      return 'CONSOLIDADO'
    end
  end

  def descripcion
    self.inicio.strftime("%Y-%m-%d").to_s + ' - ' + self.fin.strftime("%Y-%m-%d").to_s rescue nil
  end

  def descripciontirilla
    self.inicio.strftime("%Y%m%d").to_s + '_' + self.fin.strftime("%Y%m%d").to_s rescue nil
  end
end
