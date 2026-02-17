class Formatosvariable < ApplicationRecord
  belongs_to :formato
  belongs_to :variable

  validates_presence_of :variable_id, :orden, :titulo

  validates_numericality_of :orden
end
