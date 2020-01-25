class AddAnexosToJustificacion < ActiveRecord::Migration[5.1]
  def change
    add_column :justificaciones, :anexos, :json
  end
end
