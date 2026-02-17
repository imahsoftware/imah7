class Contratoscargo < ApplicationRecord
  belongs_to :contrato
  belongs_to :tiposcargo
  belongs_to :user
  belongs_to :empresassede
  has_many :contratospersonas
  has_many :contratoscaractividades
  has_many :contratoscargosnotas
  has_many :contratoscargospersonas
  has_many :contratoscargosacts
  has_many :contratoscargosdetalles
  has_many :contratosperfacts

  validates_presence_of :perfil, :cantidad, :salario, :riesgo, :requiere_dotacion, :detalle_perfil, message: "* Obligatorio"

  after_save :despuesdeguardar

  def despuesdeguardar
    ActiveRecord::Base.connection.execute("UPDATE contratoscargos SET act_economica = (CASE WHEN riesgo = '0.0052' then '1691001'
                                                                                           WHEN riesgo = '0.0104' then '2811001'
                                                                                           WHEN riesgo = '0.0243' then '3861001'
                                                                                           WHEN riesgo = '0.0435' then '4492301'
                                                                                           WHEN riesgo = '0.0696' then '5812901' end)
                                           where id = #{self.id}")
  end

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

  def desc_contrato
    self.perfil.to_s + " ($ #{self.salario rescue nil})" rescue nil
  end

  def cantregistrada
    cantregistrada1 #Contratosperfecha.where(contratoscargo_id: self.id, estado: 'ACTIVO').count rescue 0
  end

  def cantrechazados
    0
  end

  def cantdisponible
    (self.cantidad.to_i - self.cantregistrada.to_i + self.cantrechazados.to_i)
  end
end
