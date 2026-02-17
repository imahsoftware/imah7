class Eproveedorestemegreso < ApplicationRecord
  belongs_to :eproveedor
  belongs_to :cuenta
  belongs_to :user
  belongs_to :portafolio
  has_many :egresosdetalles

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

  validates_presence_of :concepto, :portafolio_id, :total, :fecha
  validates_numericality_of :total

end
