#json.key_format! camelize: :lower
json.partial! "justificaciones/justificacion", justificacion: @justificacion

json.tipo do
  if @justificacion.tipo then
    json.id @justificacion.tipo.id
    json.code @justificacion.tipo.code
    json.fraccion @justificacion.tipo.fraccion
    json.romano @justificacion.tipo.romano
    json.texto @justificacion.tipo.texto
    json.descripcion @justificacion.tipo.descripcion
  end
end
json.moneda do
  if @justificacion.moneda then
    json.id @justificacion.moneda.id
    json.code @justificacion.moneda.code
    json.nombre @justificacion.moneda.nombre
    json.simbolo @justificacion.moneda.simbolo
  end
end
json.creador do
  if @justificacion.creador then
    json.id @justificacion.creador.id
    json.clave @justificacion.creador.clave
    json.tipo @justificacion.creador.tipo
    json.nombre @justificacion.creador.nombre
    json.sede @justificacion.creador.sede
    json.cuenta_cimav @justificacion.creador.cuenta_cimav
  end
end
json.autorizo do
  if @justificacion.autorizo then
    json.id @justificacion.autorizo.id
    json.clave @justificacion.autorizo.clave
    json.tipo @justificacion.autorizo.tipo
    json.nombre @justificacion.autorizo.nombre
    json.sede @justificacion.autorizo.sede
    json.cuenta_cimav @justificacion.autorizo.cuenta_cimav
  end
end
json.elaboro do
  if @justificacion.elaboro then
    json.id @justificacion.elaboro.id
    json.clave @justificacion.elaboro.clave
    json.tipo @justificacion.elaboro.tipo
    json.nombre @justificacion.elaboro.nombre
    json.sede @justificacion.elaboro.sede
    json.cuenta_cimav @justificacion.elaboro.cuenta_cimav
  end
end
json.partida do
  if @justificacion.partida then
    json.id @justificacion.partida.id
    json.nombre @justificacion.partida.nombre
    json.texto @justificacion.partida.texto
  end
end
json.proveedores(@justificacion.proveedores) do |proveedor|
  json.id proveedor.id
  json.clave proveedor.clave
  json.justificacion_id proveedor.justificacion_id
  json.razon_social proveedor.razon_social
  json.rfc proveedor.rfc
  json.es_nacional proveedor.es_nacional
  json.fuente proveedor.fuente
  json.domicilio proveedor.domicilio
  json.contacto proveedor.contacto
  json.telefono proveedor.telefono
  json.email proveedor.email
  json.banco proveedor.banco
  json.cumple_tecnicas proveedor.cumple_tecnicas
  json.cantidad_surtir proveedor.cantidad_surtir
  json.monto proveedor.monto
  json.moneda_id proveedor.moneda_id
  json.moneda do
    if proveedor.moneda then
      json.id proveedor.moneda.id
      json.code proveedor.moneda.code
      json.nombre proveedor.moneda.nombre
      json.simbolo proveedor.moneda.simbolo
    end
  end
end
#json.anexos(@justificacion.anexos) do |anexo|
#  json.identifier anexo.file.identifier
#end
json.asesor do
  if @justificacion.asesor then
    json.id @justificacion.asesor.id
    json.clave @justificacion.asesor.clave
    json.tipo @justificacion.asesor.tipo
    json.nombre @justificacion.asesor.nombre
    json.sede @justificacion.asesor.sede
    json.cuenta_cimav @justificacion.asesor.cuenta_cimav
  end
end


