class CreateProveedores < ActiveRecord::Migration[5.1]
  def change
    create_table :proveedores do |t|

      t.string :clave

      t.references :justificacion

      t.string :razon_social
      t.string :rfc
      t.boolean :es_nacional
      t.integer :fuente
      t.string :domicilio
      t.string :contacto
      t.string :telefono
      t.string :email
      t.string :banco
      t.string :cumple_tecnicas
      t.string :cantidad_surtir
      t.decimal :monto, :precision=>10, :scale=>2

      t.timestamps

    end
  end
end
