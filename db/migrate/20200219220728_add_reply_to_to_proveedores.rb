class AddReplyToToProveedores < ActiveRecord::Migration[5.1]
  def change
    add_column :proveedores, :reply_to, :string
  end
end
