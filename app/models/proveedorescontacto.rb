class Proveedorescontacto < ApplicationRecord
  belongs_to :proveedor
  belongs_to :user
end
