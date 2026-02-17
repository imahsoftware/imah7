class Contratosprefdetalle < ApplicationRecord
  belongs_to :contratosprefactura
  belongs_to :user
  belongs_to :contratossolicitud
  #has_many :contratosprefretenciones, dependent: :destroy

  validates_presence_of :detalle, :cantidad, :valor_unitario, :iva, message: "* Obligatorio"
  validates_presence_of :tipo_producto

  #def in_us1?
  #   self.iva.to_i < 0
  #end
  before_save :antesdeguardar
  #after_save :despuesdeguardar

  def antesdeguardar
    if self.tipo_producto == 11024
      self.subtotal = 0
      self.valor_iva = self.valor_unitario.to_f * (self.iva.to_f / 100.to_f)
      self.total = self.valor_iva.to_f
    else
      self.subtotal = self.cantidad.to_f * self.valor_unitario.to_f
      self.valor_iva = self.subtotal.to_f * (self.iva.to_f / 100.to_f)
      self.total = self.subtotal.to_f + self.valor_iva.to_f
    end
  end

=begin
  def despuesdeguardar
    if Contratosretencion.where(contrato_id: self.contratosprefactura.contrato_id, tipo_producto: self.tipo_producto).exists?
      Contratosprefretencion.where(contratosprefdetalle_id: self.id).delete_all
      Contratosretencion.where(contrato_id: self.contratosprefactura.contrato_id, tipo_producto: self.tipo_producto).each do |r|
        Contratosprefretencion.create(contratosprefactura_id: self.contratosprefactura_id, contratosprefdetalle_id: self.id, contratosretencion_id: r.id,
                                      valor_retencion: (self.subtotal.to_f * (r.porcentaje.to_f / 100)))
      end
    end
  end
=end

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

  def tipoprodkey
    if self.tipo_producto.to_s == '11020'
      1549
    elsif self.tipo_producto.to_s == '11021'
      1550
    elsif self.tipo_producto.to_s == '11022'
      1551
    elsif self.tipo_producto.to_s == '11023'
      1552
    elsif self.tipo_producto.to_s == '11024'
      1553
    end
  end


  def nombredetalle
    detalle.to_s + ' ('+self.tipoproduto.to_s+')'
  end

  def tipoproduto
    if self.tipo_producto.to_s == '11020'
      'PERSONAL'
    elsif self.tipo_producto.to_s == '11021'
      'INSUMOS'
    elsif self.tipo_producto.to_s == '11022'
      'MAQUINARIA'
    elsif self.tipo_producto.to_s == '11023'
      'OTROS'
    elsif self.tipo_producto.to_s == '11024'
      'BASE G'
    end
  end


  def vlr_TotalValue
    if tipo_producto == 11024
      valor_unitario.to_f + valor_iva.to_f
    else
      subtotal.to_f + valor_iva.to_f
    end
  end

  def vlr_TaxAddId
    valor_iva.to_f > 0 ? 3286 : -1
  end

  def vlr_TaxAddPercentage
    valor_iva.to_f > 0 ? 19 : 0
  end

  def vlr_TaxAddName
    valor_iva.to_f > 0 ? 'IVA 19%' : nil
  end

  def vlr_BaseValue
    siigo_subtotal.to_f # - descuento.to_f
  end

  def vlr_GrossValue
    # tipo_producto == 11024 ? valor_unitario.to_f : subtotal.to_f
    siigo_subtotal
  end
end
