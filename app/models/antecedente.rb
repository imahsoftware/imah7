class Antecedente < ApplicationRecord
  validates_presence_of :nombre, :identificacion, :edad, :sexo, :menores5, :mayores60, :peso, :talla, :ant_1, :ant_2, :ant_3, :ant_4, :ant_5, :ant_6, :ant_7, :ant_8, :ant_9, :ant_10, :ant_11, :ant_12, :ant_13
  validates_presence_of :centro_id, if: :asear
  #validates :identificacion, uniqueness: {scope: :portafolio_id, message: "Esta identificación ya se encuentra registrada"}
  validates_uniqueness_of :identificacion
  validates_length_of :identificacion, :minimum => 6, :message => "Minimo 6 caracteres"
  validates_numericality_of :identificacion

  validates_presence_of :ant_3a, :ant_3b, :ant_3c, :ant_3d, :ant_3e, if: :valida_ant3
  validates_presence_of :ant_4a, if: :valida_ant4
  validates_presence_of :ant_5a, if: :valida_ant5

  def valida_ant3
    if self.ant_3.to_s == 'SI'
      true
    end
  end

  def valida_ant4
    if self.ant_4.to_s == 'SI'
      true
    end
  end

  def valida_ant5
    if self.ant_5.to_s == 'SI'
      true
    end
  end

  def asear
    if self.portafolio_id == 1
      true
    end
  end


  before_save :antesdeguardar

  def antesdeguardar

    ident = self.identificacion.to_s
    ident = ident.to_s.strip
    ident = ident.gsub(" ","")
    ident = ident.gsub(".","")
    ident = ident.gsub("-","")
    ident = ident.gsub(",","")
    ident = ident.gsub("_","")
    ident = ident.gsub("/","")
    self.identificacion = ident

    if self.ant_3.to_s == 'NO'
      self.ant_3a = ""
      self.ant_3b = ""
      self.ant_3c = ""
      self.ant_3d = ""
      self.ant_3e = ""
    end
    if self.ant_5.to_s == 'NO'
      self.ant_5a = ""
    end
    if self.ant_4.to_s == 'NO'
      self.ant_4a = ""
    end
  end

  def nombreportafolio
    if self.portafolio_id == 1
      'ASEAR S.A. E.S.P'
    elsif self.portafolio_id == 2
      'MICROCINCO'
    elsif self.portafolio_id == 3
      'CONSTRUMATER'
    end
  end

end
