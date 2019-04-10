class AddStatusToJustificaciones < ActiveRecord::Migration[5.1]
  def change
    add_column :justificaciones, :status, :integer, :default=>0
  end
end
