class Contratosperproceso < ApplicationRecord
  belongs_to :contratospersona
  belongs_to :contratosperfecha
  belongs_to :user

  has_many :contratosperprodocs, dependent: :destroy
  has_many :contratosperprocitaciones, dependent: :destroy
  has_many :contratosperprodescargos, dependent: :destroy
  has_many :contratosperprosanciones, dependent: :destroy
  has_many :contratosperpronotas, dependent: :destroy

  validates_presence_of :clase, :fecha, :detalle, :apertura

  has_attached_file :firma_abogado_doc, styles: { thumb: '150x150>' }
  validates_attachment_content_type :firma_abogado_doc, content_type: /\Aimage\/.*\z/

  has_attached_file :firma_testigo1_doc, styles: { thumb: '150x150>' }
  validates_attachment_content_type :firma_testigo1_doc, content_type: /\Aimage\/.*\z/

  has_attached_file :firma_testigo2_doc, styles: { thumb: '150x150>' }
  validates_attachment_content_type :firma_testigo2_doc, content_type: /\Aimage\/.*\z/

  has_attached_file :firma_usuario_doc, styles: { thumb: '150x150>' }
  validates_attachment_content_type :firma_usuario_doc, content_type: /\Aimage\/.*\z/

  def mostrar_movil
    if self.user.celular.present? and self.user.celular.to_i > 0
      self.user.celular
    else
      if self.user.identificacion.present?
        if Contratospersona.where("identificacion = '#{self.user.identificacion}'").first.movil.present?
          Contratospersona.where("identificacion = '#{self.user.identificacion}'").first.movil rescue nil
        else
          'Sin Nro Celular Registrado'
        end
      else
        'Sin Nro Celular Registrado'
      end
    end
  end
end
