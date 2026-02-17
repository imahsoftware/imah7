class Personastemporal < ApplicationRecord
  belongs_to :contrato
  belongs_to :user
  belongs_to :contratoscargo

  validates_presence_of :tipo_identificacion, :identificacion, :nombres, :apellidos, :contratoscargo_id
  validate :telefono, :movil, if: :validaruntelefono
  validates :identificacion, uniqueness: {scope: :contrato_id,
                                          message: "Una persona ya existe con ese documento"}
  before_save :antesdeguardar

  def validaruntelefono
    if self.contratoscargo.cantdisponible <= 0
      errors.add :contratoscargo_id, "Ya no hay cupos en este cargo.."
    end
    if self.telefono.to_s == "" and self.movil.to_s == ""
      errors.add :telefono, "Debe ingresar un telefono"
      errors.add :movil, "Debe ingresar un telefono"
    else
      if self.telefono.to_s != ""
        if self.telefono.to_s.length > 7
          errors.add :telefono, "El número debe tener 7 dígitos"
        elsif self.telefono.to_s.length < 7
          errors.add :telefono, "El número debe tener 7 dígitos"
        end
      end
      if self.movil.to_s != ""
        if self.movil.to_s.length > 10
          errors.add :movil, "El número debe tener 10 dígitos"
        elsif self.movil.to_s.length < 10
          errors.add :movil, "El número debe tener 10 dígitos"
        end
      end
    end
  end

  def antesdeguardar
    self.nombres = quita_acento(self.nombres)
    self.apellidos = quita_acento(self.apellidos)
    nom = ""
    nom2 = ""
    if self.identificacion.nil? == false
      nom = self.identificacion.to_s
    end
    if self.nombres.nil? == false
      nom = nom + ' ' + self.nombres.to_s
      nom2 = self.nombres.to_s
    end
    if self.apellidos.nil? == false
      nom = nom + ' ' + self.apellidos.to_s
      nom2 = nom2 + ' ' + self.apellidos.to_s
    end
    self.autobuscar = nom
    self.nombre_completo = nom2
    self.tipo_usuario = 'NUEVO'
  end

  def quita_acento(dato)
    valor = dato.gsub('Á', 'A') rescue nil
    valor = valor.gsub('É', 'E') rescue nil
    valor = valor.gsub('Í', 'I') rescue nil
    valor = valor.gsub('Ó', 'O') rescue nil
    valor = valor.gsub('Ú', 'U') rescue nil
    #valor = valor.gsub('Ñ', 'N') rescue nil
    return valor.to_s
  end

end
