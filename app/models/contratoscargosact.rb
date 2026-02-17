class Contratoscargosact < ApplicationRecord
  belongs_to :contratoscargo
  belongs_to :user

  validates_presence_of :descripcion, :estado
end
