class Personasevaluacion < ApplicationRecord
  belongs_to :persona
  validates_presence_of :eva_1,:eva_2,:eva_3,:eva_4,:eva_5,:eva_6,:eva_7,:eva_8,:eva_9

end
