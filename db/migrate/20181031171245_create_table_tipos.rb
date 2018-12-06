class CreateTableTipos < ActiveRecord::Migration[5.1]
  def change
    create_table :tipos do |t|
      t.string :code
      t.integer :fraccion

      t.timestamps
    end
  end
end
