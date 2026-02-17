class Tiposnaporte < ApplicationRecord
  has_many :tiposnovedades

  def descripcionampliada
    if subtipo.to_s != ""
      return self.tipo.to_s + '-' + self.subtipo + ' : ' + self.descripcion
    else
      return self.tipo.to_s + ' : ' + self.descripcion
    end
  end

  def descripcioncorta
    if subtipo.to_s != ""
      return self.tipo.to_s + '-' + self.subtipo
    else
      return self.tipo.to_s
    end
  end



end
