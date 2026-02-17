class Contratosproyecto < ApplicationRecord
  belongs_to :contrato
  belongs_to :user
  has_many :contratosprosedes, dependent: :destroy
end
