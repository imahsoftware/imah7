class Contratosprefretencion < ApplicationRecord
  belongs_to :contratosprefactura
  #belongs_to :contratosprefdetalle
  belongs_to :contratosretencion
end
