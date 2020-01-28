class Proveedor < ApplicationRecord

  belongs_to :justificacion
  belongs_to :moneda

end
