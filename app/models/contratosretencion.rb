class Contratosretencion < ApplicationRecord
  belongs_to :contrato
  belongs_to :user
  belongs_to :tipospretencion

  validates_presence_of :tipospretencion_id,:estado, message: "* Obligatorio"

  def tipoproduto
    if self.tipo_producto.to_s == '11020'
      'PERSONAL'
    elsif self.tipo_producto.to_s == '11021'
      'INSUMOS'
    elsif self.tipo_producto.to_s == '11022'
      'MAQUINARIA'
    elsif self.tipo_producto.to_s == '11023'
      'OTROS'
    end
  end

  def nomretencion
    tiposretencion.detalle.to_s
  end
end
