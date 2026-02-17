class Contratossecuser < ApplicationRecord
  belongs_to :contratosseccion
  belongs_to :user

  validates_presence_of :user_id
end
