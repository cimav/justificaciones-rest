class AddProyectoDescripcionToJustificacion < ActiveRecord::Migration[5.1]
  def change
    add_column :justificaciones, :proyecto_objeto, :text
  end
end
