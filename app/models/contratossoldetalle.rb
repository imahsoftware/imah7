class Contratossoldetalle < ApplicationRecord
  belongs_to :contratossolicitud
  belongs_to :user
  belongs_to :contratosinsumo
  belongs_to :contratosmaquinaria
  belongs_to :contratosotro
  belongs_to :insumo

  #validates_presence_of :cantidad, message: "* Obligatorio"
  validates_presence_of :contratosinsumo_id, message: "* Obligatorio", if: :etapa_a
  validates_presence_of :contratosmaquinaria_id, message: "* Obligatorio", if: :etapa_b
  validates_presence_of :contratosotro_id, message: "* Obligatorio", if: :etapa_c

  before_save :antesdeguardar

  def etapa_a
    self.contratossolicitud.etapa.to_s == 'A'
  end

  def etapa_b
    self.contratossolicitud.etapa.to_s == 'B'
  end

  def etapa_c
    self.contratossolicitud.etapa.to_s == 'C'
  end

  def antesdeguardar
    cant = 0
    Contratossede.where(["contrato_id = #{self.contratossolicitud.contrato_id} and id in (select sede from sedesactivas where contrato_id = #{self.contratossolicitud.contrato.id} and user_interventor = #{self.contratossolicitud.user_id})"]).each do |a|
      cant = cant + eval("self.cantsede_"+a.ordensede.to_s).to_f
    end
    self.cantidad = cant
    if self.contratossolicitud.etapa.to_s == 'A'
      self.cantidad_real = self.cantidad
      self.precio_unitario = self.contratosinsumo.precio_condescuento
      self.total = (self.cantidad_real * self.precio_unitario)
      self.porc_iva = self.contratosinsumo.porc_iva
      self.valor_iva = self.contratosinsumo.valor_iva
      self.precio_siniva = self.contratosinsumo.precio_unitario
    elsif self.contratossolicitud.etapa.to_s == 'B'
      self.cantidad_real = self.cantidad
      self.precio_unitario = self.contratosmaquinaria.precio_condescuento
      self.total = (self.cantidad_real * self.precio_unitario)
    elsif self.contratossolicitud.etapa.to_s == 'C'
      self.cantidad_real = self.cantidad
      self.precio_unitario = self.contratosotro.precio_condescuento
      self.total = (self.cantidad_real * self.precio_unitario)
    end
  end

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

  def nombreinsumo
    dato = ""
    if self.contratossolicitud.etapa.to_s == 'A'
      dato = self.contratosinsumo.insumo_cliente rescue nil
    elsif self.contratossolicitud.etapa.to_s == 'B'
      dato = self.contratosmaquinaria.insumo.insumodetallesolicitud rescue nil
    elsif self.contratossolicitud.etapa.to_s == 'C'
      dato = self.contratosotro.descripcion rescue nil
    end
    if dato.length.to_i > 100
      return dato[0...100].to_s + ' ...'
    else
      return dato
    end
  end

  def nombreinsumo_by_etapa(vcEtapa)
    if vcEtapa.to_s == 'A'
      self.contratosinsumo.insumo.insumodetalle rescue nil
    elsif vcEtapa.to_s == 'B'
      self.contratosmaquinaria.insumo.insumodetalle rescue nil
    elsif vcEtapa.to_s == 'C'
      self.contratosotro.descripcion rescue nil
    end
  end

  def nombreinsumoe_by_etapa(vcEtapa)
    if vcEtapa.to_s == 'A'
      self.contratosinsumo.insumo_cliente rescue nil
    elsif vcEtapa.to_s == 'B'
      self.contratosmaquinaria.insumo.insumodetalle rescue nil
    elsif vcEtapa.to_s == 'C'
      self.contratosotro.descripcion rescue nil
    end
  end

end
