class CreateAsistentes < ActiveRecord::Migration[5.1]
  def change
    create_table :asistentes do |t|
      t.integer :asistente_id
      t.integer :creador_id
    end
  end
end
