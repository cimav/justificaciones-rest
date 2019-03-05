# json.key_format! camelize: :lower
json.extract! justificacion,
              :id, :creador_id, :tipo_id, :elaboro_id, :autorizo_id,
              :proveedor_id,
              :moneda_id, :requisicion, :identificador, :proyecto, :bien_servicio,
              :iva, :condiciones_pago, :razon_compra, :terminos_entrega, :plazo,
              :fecha_inicio, :fecha_termino, :fecha_elaboracion, :descripcion,
              :num_pagos, :porcen_anticipo, :autoriza_cargo, :forma_pago,
              :num_dias_plazo, :motivo_seleccion, :identificador, :partida_id,
              :economica, :eficiencia_eficacia, :lugar_entrega, :porcen_garantia, :fecha_cotizar,
              :fecha_mercado

#
json.url justificacion_url(justificacion, format: :json)


