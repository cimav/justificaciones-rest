class AddMonedaToProveedores < ActiveRecord::Migration[5.1]
  def change
    add_reference :proveedores, :moneda
  end
end
