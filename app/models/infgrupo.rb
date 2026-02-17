class Infgrupo < ApplicationRecord

  def nombregrupo
    id.to_s + ' - ' + nombre.to_s + ' (' + tipo.to_s + ')'
  end
end
