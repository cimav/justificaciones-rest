class CreateJustificaciones < ActiveRecord::Migration[5.1]
  def change
    create_table :justificaciones do |t|

      t.integer :creador_id
      t.integer :elaboro_id
      t.integer :autorizo_id

      t.references :tipo, foreign_key: true
      t.references :partida, foreign_key: true

      t.integer :proveedor_id

      t.string :identificador
      t.string :requisicion
      t.string :proyecto
      t.integer :bien_servicio
      t.decimal :iva, :precision=>10, :scale=>2
      t.text :condiciones_pago
      t.string :banco
      t.text :razon_compra
      t.string :terminos_entrega
      t.integer :plazo
      t.date :fecha_inicio
      t.date :fecha_termino
      t.date :fecha_elaboracion
      t.text :descripcion
      t.references :moneda, foreign_key: true
      t.integer :num_pagos
      t.integer :porcen_anticipo
      t.string :autoriza_cargo
      t.string :forma_pago
      t.integer :num_dias_plazo
      t.text :motivo_seleccion
      t.boolean :economica, :default=> true
      t.integer :eficiencia_eficacia, :default=> 0
      t.string :lugar_entrega
      t.integer :porcen_garantia, :default=> 0
      t.date :fecha_cotizar

      t.timestamps
    end
  end
end
