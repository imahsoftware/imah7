class Migracionesuser < ApplicationRecord
  belongs_to :migracion
  belongs_to :user
end
