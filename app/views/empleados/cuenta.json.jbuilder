json.partial! "empleados/empleado", empleado: @empleado

#json.extract! empleado, :id, :tipo, :clave, :nombre, :sede, :cuenta_cimav, :is_admin
#json.url empleado_url(empleado, format: :json)