class Eproveedorestempcompra < ApplicationRecord
  belongs_to :eproveedor
  belongs_to :eproveedorescompra
  belongs_to :cuenta
  belongs_to :user

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

  validates_presence_of :eproveedorescompra_id, :total, :fecha
  validates_numericality_of :total
  validate :saldofactura

  def saldofactura
    if self.eproveedorescompra_id
      proveedorescompra = Eproveedorescompra.find(self.eproveedorescompra_id)
      if self.total.to_i > proveedorescompra.saldo.to_i
        errors.add :total, "* El valor pagado es superior al saldo de la causacion"
      end
    end
  end
=begin
  def after_create

    vlr = Proveedorestempcompra.sum("total",:conditions=>["cliente_id = #{self.cliente_id} and proveedorescompra_id = #{self.proveedorescompra_id}"])
    vlr1 = Egresosdetalle.sum("total",:conditions=>["cliente_id = #{self.cliente_id} and proveedorescompra_id = #{self.proveedorescompra_id}"])
    vlr2 = Proveedorescredito.sum("cuenta_cobrar",:conditions=>["cliente_id = #{self.cliente_id} and proveedorescompra_id = #{self.proveedorescompra_id}"]) rescue 0
    # 2018-08-29 FFA
    vlr3 = 0
    if Proveedoresajuste.exists?(["cliente_id = #{self.cliente_id} and proveedorescompra_id = #{self.proveedorescompra_id}"]) == true
      vlr3_1 = Proveedoresajuste.sum("valord1",:conditions=>["cliente_id = #{self.cliente_id} and proveedorescompra_id = #{self.proveedorescompra_id}"]) rescue 0
      vlr3_2 = Proveedoresajuste.sum("valord2",:conditions=>["cliente_id = #{self.cliente_id} and proveedorescompra_id = #{self.proveedorescompra_id}"]) rescue 0
      vlr3_3 = Proveedoresajuste.sum("valord3",:conditions=>["cliente_id = #{self.cliente_id} and proveedorescompra_id = #{self.proveedorescompra_id}"]) rescue 0
      vlr3_4 = Proveedoresajuste.sum("valord4",:conditions=>["cliente_id = #{self.cliente_id} and proveedorescompra_id = #{self.proveedorescompra_id}"]) rescue 0
      vlr3_5 = Proveedoresajuste.sum("valord5",:conditions=>["cliente_id = #{self.cliente_id} and proveedorescompra_id = #{self.proveedorescompra_id}"]) rescue 0
      vlr3 = vlr3_1.to_f + vlr3_2.to_f + vlr3_3.to_f + vlr3_4.to_f + vlr3_5.to_f
    end
    ActiveRecord::Base.connection.execute("update proveedorescompras set saldo = cuenta_cobrar - #{vlr} - #{vlr1} - #{vlr2} - #{vlr3}
                                           where  id = #{self.proveedorescompra_id}")
  end
=end

end
