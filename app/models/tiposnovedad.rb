class Tiposnovedad < ApplicationRecord

  belongs_to :tiposnaporte

  def descripcionampliada
    #self.descripcion.to_s + ' (' + self.tipo.to_s + ' - ' + (self.porcentaje.to_f / 100).to_s +  '%)'
    numerodeno = ""
    if self.multiplica.to_s == 'SI'
      numerodeno = 'DIAS'
    else
      numerodeno = 'HORAS'
    end
    self.descripcion.to_s + ' (**** EN ' + numerodeno.to_s + ' ****)'
  end

end
