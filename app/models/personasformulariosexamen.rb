class Personasformulariosexamen < ApplicationRecord
  belongs_to :personasformulario
  belongs_to :user
  has_many :personasforexadocs, dependent: :destroy

  validates_presence_of :descripcion, :estado, message: "* Obligatorio"

  def user_actnombre
    if self.user_act.to_i > 0
      "<br/>Ult.Act: (#{User.find(self.user_act).username rescue nil}) <br/>#{self.updated_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
    end
  end

  def user_nombre
    "Creación: (#{self.user.username rescue nil}) <br/>#{self.created_at.strftime('%Y-%m-%d %X') rescue nil}" rescue nil
  end

end
