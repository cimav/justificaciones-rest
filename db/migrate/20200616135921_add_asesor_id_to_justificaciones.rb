class AddAsesorIdToJustificaciones < ActiveRecord::Migration[5.1]
  def change
     add_column :justificaciones, :asesor_id, :integer	
  end
end
