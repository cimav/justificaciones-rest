# json.key_format! camelize: :lower
json.extract! empleado, :id, :tipo, :clave, :nombre, :sede, :cuenta_cimav, :is_admin, :is_asistente
json.url empleado_url(empleado, format: :json)
