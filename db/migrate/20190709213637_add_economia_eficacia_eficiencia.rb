class AddEconomiaEficaciaEficiencia < ActiveRecord::Migration[5.1]
  def change
    add_column :justificaciones, :economica_txt, :text

    add_column :justificaciones, :eficiente, :boolean, :default=>false
    add_column :justificaciones, :eficiente_txt, :text

    add_column :justificaciones, :eficaz, :boolean, :default=>false
    add_column :justificaciones, :eficaz_txt, :text
  end
end
