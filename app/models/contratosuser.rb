class Contratosuser < ApplicationRecord
  belongs_to :contrato
  belongs_to :user
  belongs_to :empresassede

  validates_presence_of :tipo, :fecha_inicio, :multiples_solicitudes, :marca_entrega_sitio, message: "* Obligatorio"

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

end
