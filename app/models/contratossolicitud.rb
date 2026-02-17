class Contratossolicitud < ApplicationRecord
  belongs_to :contrato
  belongs_to :user
  has_many :contratossoldetalles, dependent: :destroy
  has_many :contratossolbitacoras, dependent: :destroy
  has_many :contratossolotros, dependent: :destroy
  has_many :contratossolnotas, dependent: :destroy
  has_many :contratossolicitudes

  def datosol
    dato = ""
    if self.etapa.to_s == 'A'
      dato = ' contratosinsumo_id is not null and precio_unitario > 0'
    elsif self.etapa.to_s == 'B'
      dato = ' contratosmaquinaria_id is not null and precio_unitario > 0'
    elsif self.etapa.to_s == 'C'
      dato = ' contratosotro_id is not null'
    elsif self.etapa.to_s == 'D'
      dato = ' insumo_id is not null'
    end
    dato
  end

  def total
    vlr1 = self.contratossoldetalles.sum("total") rescue 0
    vlr2 = self.contratossolotros.sum("total") rescue 0
    (vlr1 + vlr2)
  end

  def namebyprefact
    self.periodo.to_s + ' - Solicitud Nro. ' + self.id.to_s + ' - Estado: ' + self.estado.to_s + ' - Solicitante: ' + self.user.nombre.to_s rescue nil
  end

  def budget
    if Contratosproyecto.where(contrato_id: self.contrato_id).exists? and self.estado.to_s == 'PENDIENTE'
      ActiveRecord::Base.connection.execute("CALL prc_pruebarecursos(#{self.contrato_id},#{self.user_id},#{self.id})")
      estado = Contratossolicitud.select(:presup_estado).find(self.id).presup_estado.to_s rescue nil
      if estado.to_s == ""
        return 'OK'
      else
        return estado
      end
      #return Contratossolicitud.select(:presup_estado).find(self.id).presup_estado.to_s
    else
      return 'OK'
    end
  end
end


