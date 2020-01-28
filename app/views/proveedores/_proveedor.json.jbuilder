json.extract! proveedor, :id, :razon_social, :rfc, :clave, :justificacion_id, :es_nacional, :fuente, :domicilio,
              :contacto, :telefono, :email, :banco, :cumple_tecnicas, :cantidad_surtir, :monto, :moneda_id

json.url proveedor_url(proveedor, format: :json)
