class Migracionespersona < ApplicationRecord
  belongs_to :user
  belongs_to :archivo
end
