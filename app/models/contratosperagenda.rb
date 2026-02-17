class Contratosperagenda < ApplicationRecord
  belongs_to :contratospersona
  belongs_to :user
end
