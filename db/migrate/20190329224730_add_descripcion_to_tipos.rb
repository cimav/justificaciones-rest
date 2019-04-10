class AddDescripcionToTipos < ActiveRecord::Migration[5.1]
  def change
    add_column :tipos, :descripcion, :text
  end
end
