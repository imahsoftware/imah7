class Migracionescuenta < ApplicationRecord
  belongs_to :user
  belongs_to :archivo
end
