class Contratosinsumo < ApplicationRecord
  belongs_to :contrato
  belongs_to :insumo
  belongs_to :user
  belongs_to :empresassede
  has_many :contratosinsimagenes

  validates_presence_of :insumo_id,:precio_unitario,:descuento, message: "* Obligatorio"

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

  before_save :antesdeguardar

  def antesdeguardar
    if self.contrato.claseinsumos.to_s == 'GENERAL'
      self.cantidad_mensual = self.cantsede_1.to_f + self.cantsede_2.to_f + self.cantsede_3.to_f + self.cantsede_4.to_f + self.cantsede_5.to_f + self.cantsede_6.to_f + self.cantsede_7.to_f + self.cantsede_8.to_f + self.cantsede_9.to_f + self.cantsede_10.to_f
      self.precio_condescuento = self.precio_unitario.to_f - (self.precio_unitario.to_f * (self.descuento.to_f / 100))
      self.total = self.precio_condescuento * self.cantidad_mensual
    else
      self.insumocce = self.insumo.insumoid
      if self.insumo.insumoid.to_i > 0
        self.insumo_cliente = Insumo.find(self.insumo.insumoid).insumodetalleccf.to_s
      end
    end
  end

  def descinsumo
    self.insumo.insumodetalle rescue nil
  end

  def insumobyiva
    self.insumo_cliente.to_s + ' - IVA: ' + self.porc_iva.to_s + '%'
  end

end
