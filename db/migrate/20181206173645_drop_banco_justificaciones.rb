class DropBancoJustificaciones < ActiveRecord::Migration[5.1]
  def change
    remove_column :justificaciones, :banco
  end
end
