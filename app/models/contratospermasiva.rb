class Contratospermasiva < ApplicationRecord
  include InformationConcern

  belongs_to :contrato
  belongs_to :contratosgrupo
  belongs_to :contratoscargo
  belongs_to :user
  has_many :contratospermasdetalles, dependent: :destroy
end
