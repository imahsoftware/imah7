class Contratospago < ApplicationRecord
  belongs_to :contrato
  belongs_to :user
  belongs_to :tiposcuenta
  belongs_to :contratosprefactura

  validates_presence_of :contratosprefactura_id, :fecha_pago, :valor, message: "* Obligatorio"
  validates_numericality_of :valor

  validate :abonos

  def abonos
    if !self.id.present?
      if self.valor.to_f > 0 and self.valor.to_i > self.contratosprefactura.saldo.to_f
        errors.add :valor, "El valor es superior al saldo"
      end
      vlrRetencion = 0
      datos = self.contrato.contratosretenciones.order(id: :asc)
      datos.each do |a|
        dato = "self.rete_"+a.tipospretencion_id.to_s
        vlrRetencion = vlrRetencion + eval(dato).to_f
      end
      self.valor_retencion = vlrRetencion
      if vlrRetencion > self.valor.to_f
        errors.add :valor, "Las retenciones no pueden ser mayor que el valor pagado"
      end
    else
      vlrRetencion = 0
      datos = self.contrato.contratosretenciones.order(id: :asc)
      datos.each do |a|
        dato = "self.rete_"+a.tipospretencion_id.to_s
        vlrRetencion = vlrRetencion + eval(dato).to_f
      end
      self.valor_retencion = vlrRetencion
      if vlrRetencion > self.valor.to_f
        errors.add :valor, "Las retenciones no pueden ser mayor que el valor pagado"
      end
    end
  end

  def totalgeneral
    valor.to_f + valor_retencion.to_f rescue 0
  end

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end
end
