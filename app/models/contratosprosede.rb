class Contratosprosede < ApplicationRecord
  belongs_to :contratosproyecto
  belongs_to :user
  belongs_to :contratossede

  validates_presence_of :contratossede_id
end
