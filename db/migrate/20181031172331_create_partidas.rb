class CreatePartidas < ActiveRecord::Migration[5.1]
  def change
    create_table :partidas do |t|
      t.string :nombre
      t.references :tipo
    end
  end
end
