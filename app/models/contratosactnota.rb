class Contratosactnota < ApplicationRecord
  belongs_to :contratosactividad
  belongs_to :contratossede
  belongs_to :user
end
