class Contratosenteppsdetalle < ApplicationRecord
  belongs_to :contratosentepp
  validates_presence_of :contratosperfecha_id, :cantidad, :item


  def envio_usuario(params)
    @param =   params
  end

  validate :valida_cantidad

  def valida_cantidad
    cnt = Contratosenteppsdetalle.where("item = ? AND user_id = #{@param}", item).sum(:cantidad).to_i
    total = cnt.to_i + cantidad.to_i
    cant_aprobada = Contratossoleppsdetalle
                      .joins("INNER JOIN contratossolepps ON contratossolepps.id = contratossoleppsdetalles.contratossolepp_id")
                      .where("contratossolepps.estado = ? AND contratossoleppsdetalles.item = ? AND contratossolepps.user_id = #{@param}", 'ENTREGADO', item)
                      .sum(:cant_aprobada)

    if total > cant_aprobada
      resultado = total - cant_aprobada
      errors.add :cantidad, "Superó el total establecido - Descuéntale: #{resultado}"
    end
  end
end
