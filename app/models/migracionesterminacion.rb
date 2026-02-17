class Migracionesterminacion < ApplicationRecord
  belongs_to :user
  belongs_to :archivo
  belongs_to :contratosperfecha
  belongs_to :contratospersona
end
