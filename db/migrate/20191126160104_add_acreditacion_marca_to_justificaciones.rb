class AddAcreditacionMarcaToJustificaciones < ActiveRecord::Migration[5.1]
  def change
    add_column :justificaciones, :acreditacion_marca, :text
  end
end
