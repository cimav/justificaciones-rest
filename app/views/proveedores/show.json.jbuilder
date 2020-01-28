json.partial! "proveedores/proveedor", proveedor: @proveedor

json.moneda do
  if @proveedor.moneda then
    json.id @proveedor.moneda.id
    json.code @proveedor.moneda.code
    json.nombre @proveedor.moneda.nombre
    json.simbolo @proveedor.moneda.simbolo
  end
end
