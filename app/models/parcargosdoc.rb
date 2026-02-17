class Parcargosdoc < ApplicationRecord
  belongs_to :parcargo
  belongs_to :user

  validates_presence_of :descripcion, :obligatorio, :estado
end
