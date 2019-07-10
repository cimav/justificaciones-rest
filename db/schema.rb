# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190709213637) do

  create_table "asistentes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "asistente_id"
    t.integer "creador_id"
  end

  create_table "justificaciones", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "creador_id"
    t.integer "elaboro_id"
    t.integer "autorizo_id"
    t.bigint "tipo_id"
    t.bigint "partida_id"
    t.integer "proveedor_id"
    t.string "identificador", null: false, collation: "utf8_general_ci"
    t.string "requisicion", null: false, collation: "utf8_general_ci"
    t.string "proyecto"
    t.integer "bien_servicio"
    t.decimal "iva", precision: 10, scale: 2
    t.text "condiciones_pago", null: false, collation: "utf8_general_ci"
    t.text "razon_compra"
    t.string "terminos_entrega"
    t.integer "plazo"
    t.date "fecha_inicio"
    t.date "fecha_termino"
    t.date "fecha_elaboracion"
    t.text "descripcion", null: false, collation: "utf8_general_ci"
    t.bigint "moneda_id"
    t.integer "num_pagos"
    t.integer "porcen_anticipo"
    t.string "autoriza_cargo"
    t.string "forma_pago"
    t.integer "num_dias_plazo"
    t.text "motivo_seleccion", null: false, collation: "utf8_general_ci"
    t.boolean "economica", default: true
    t.integer "eficiencia_eficacia", default: 0
    t.string "lugar_entrega"
    t.integer "porcen_garantia", default: 0
    t.date "fecha_cotizar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "fecha_mercado"
    t.integer "status", default: 0
    t.text "economica_txt"
    t.boolean "eficiente", default: false
    t.text "eficiente_txt"
    t.boolean "eficaz", default: false
    t.text "eficaz_txt"
    t.index ["moneda_id"], name: "index_justificaciones_on_moneda_id"
    t.index ["partida_id"], name: "index_justificaciones_on_partida_id"
    t.index ["tipo_id"], name: "index_justificaciones_on_tipo_id"
  end

  create_table "monedas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "code"
    t.string "nombre"
    t.string "simbolo"
  end

  create_table "partidas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "nombre"
    t.bigint "tipo_id"
    t.index ["tipo_id"], name: "index_partidas_on_tipo_id"
  end

  create_table "proveedores", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "clave"
    t.bigint "justificacion_id"
    t.string "razon_social"
    t.string "rfc"
    t.boolean "es_nacional"
    t.integer "fuente"
    t.string "domicilio"
    t.string "contacto"
    t.string "telefono"
    t.string "email"
    t.string "banco"
    t.string "cumple_tecnicas"
    t.string "cantidad_surtir"
    t.decimal "monto", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["justificacion_id"], name: "index_proveedores_on_justificacion_id"
  end

  create_table "tipos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "code"
    t.integer "fraccion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "descripcion"
  end

  add_foreign_key "justificaciones", "monedas"
  add_foreign_key "justificaciones", "partidas"
  add_foreign_key "justificaciones", "tipos"
end
