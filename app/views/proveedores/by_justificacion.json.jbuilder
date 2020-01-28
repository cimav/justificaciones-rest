json.array!(@proveedores) do | proveedor|
  json.extract! proveedor, :id, :razon_social, :rfc, :clave, :justificacion_id, :es_nacional, :fuente, :domicilio,
                :contacto, :telefono, :email, :banco, :cumple_tecnicas, :cantidad_surtir, :monto, :moneda_id
  json.moneda do
    if proveedor.moneda then
      json.id proveedor.moneda.id
      json.code proveedor.moneda.code
      json.nombre proveedor.moneda.nombre
      json.simbolo proveedor.moneda.simbolo
    end
  end
end
