class Veriserviciosuser < ApplicationRecord
  belongs_to :veriservicio
  belongs_to :veriserviciosagenda
  belongs_to :user

  validates_presence_of :user_id
end
