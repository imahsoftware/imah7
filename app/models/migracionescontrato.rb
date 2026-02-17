class Migracionescontrato < ApplicationRecord
  belongs_to :user
  belongs_to :archivo
end
