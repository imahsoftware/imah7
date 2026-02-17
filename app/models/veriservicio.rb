class Veriservicio < ApplicationRecord
  belongs_to :contrato
  belongs_to :user
  belongs_to :contratossede
  has_many :veriserviciosusers, dependent: :destroy
  has_many :veriserviciositems, dependent: :destroy
  has_many :veriserviciosagendas, dependent: :destroy

  validates_presence_of :contrato_id

  def estado_color
    if estado_proceso == 'PENDIENTE'
      "<span class='label label-warning' style='font-size: 15px;'>PENDIENTE</span>".html_safe
    elsif estado_proceso == 'EN PROCESO'
      "<span class='label label-primary' style='font-size: 15px;'>EN PROCESO</span>".html_safe
    elsif estado_proceso == 'FINALIZADO'
      "<span class='label label-success' style='font-size: 15px;'>FINALIZADO</span>".html_safe
    end
  end

  def self.search(contrato_id, estado_proceso, page, nroreg)
    cadena = []
    if contrato_id.to_s != ""
      cadena << " contrato_id = '#{contrato_id}' "
    end
    if estado_proceso.to_s != ""
      cadena << " estado_proceso = '#{estado_proceso}' "
    end
    if cadena.size > 0
      sqlDatos = ""
      sqlDatos << " #{cadena.join(" and ")}"
      paginate(page: page, per_page: nroreg).where("#{sqlDatos}").order('created_at desc')
    else
      paginate(page: page, per_page: nroreg).where("objetivo = '-1'").order('created_at desc')
      # Insumo.where("bien_servicio = '-1'", nroreg).order('id')
    end
  end

  def self.replacespace(campo)
    b = campo.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b = b.sub(" ", "%%")
    b
  end

  validate :validar_solicitar_sede

  private

  def validar_solicitar_sede
    if contrato_id.present? && contrato.contratossedes.exists?
      if contratossede_id.blank? || contratossede_id == 0
        errors.add(:contratossede_id, "Debes Seleccionar una sede")
      end
    end
  end
end
