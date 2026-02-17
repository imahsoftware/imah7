class Evaluacionesejecucion < ApplicationRecord
  belongs_to :evaluacionescontrato # usuarios
  belongs_to :evaluacion
  belongs_to :evaluacionesdetalle # items
  belongs_to :user

  has_many :evaluacionesejecucionesdocs, dependent: :destroy

  def boton_estado
    if self.estado.to_s == '0'
      "danger"
    elsif self.estado.to_s == '1'
      "success"
    else
      "info"
    end
  end

  def boton_estado_prueba
    if self.estado.to_s == '1'
      "background-color: #d33724; color: white; border-color: #d33724;"
    elsif self.estado.to_s == '2'
      "background-color: #ff7701; color: white; border-color: #ff7701;"
    elsif self.estado.to_s == '3'
      "background-color: #555299; color: white; border-color: #555299;"
    elsif self.estado.to_s == '4'
      "background-color: #008d4c; color: white; border-color: #008d4c;"
    else
      "background-color: #357ca5; color: white; border-color: #357ca5;"
    end
  end

  def estado_prueba
    if estado == '1'
      "<small class='label pull-right bg-red'>Deficiente</small>".html_safe
    elsif estado == '2'
      "<small class='label pull-right bg-blue'>Regular</small>".html_safe
    elsif estado == '3'
      "<small class='label pull-right bg-yellow'>Bueno</small>".html_safe
    elsif estado == '4'
      "<small class='label pull-right bg-green'>Excelente</small>".html_safe
    end
  end

  def calcula_estado
    if self.estado.to_s == ''
      "Pendiente"
    elsif self.estado.to_s == '1'
      "Cumple"
    elsif self.estado.to_s == '1.0'
      "No Aplica"
    elsif self.estado.to_s == '0.5'
      "Parcialmente"
    elsif self.estado.to_s == '0'
      "No Cumple"
    end
  end

  def calcula_estado_prueba
    if self.estado.to_s == '1'
      "Deficiente"
    elsif self.estado.to_s == '2'
      "Regular"
    elsif self.estado.to_s == '3'
      "Bueno"
    elsif self.estado.to_s == '4'
      "Excelente"
    end
  end

end
