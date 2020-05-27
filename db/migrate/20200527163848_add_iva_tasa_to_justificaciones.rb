class AddIvaTasaToJustificaciones < ActiveRecord::Migration[5.1]
  def change
    add_column :justificaciones, :iva_tasa, :integer, default: 1
  end
end
