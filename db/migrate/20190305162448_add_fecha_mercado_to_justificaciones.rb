class AddFechaMercadoToJustificaciones < ActiveRecord::Migration[5.1]
  def change
    add_column :justificaciones, :fecha_estudio, :date
  end
end
