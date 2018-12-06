class ProveedoresNetmultixController  < ApplicationController

  def index
    @proveedores_netmultix = ProveedorNetmultix
                       .select("pv01_clave as clave,
                       TRIM(pv01_rfc) as rfc,
                       TRIM(pv01_nombre) as razon_social,
                       TRIM(pv01_contacto) as contacto,
                       CONCAT(TRIM(pv01_direccion), ', ', TRIM(pv01_colonia), ', ', TRIM(pv01_ciudad), ', ', TRIM(pv01_codigo_postal)) as domicilio,
                       CONCAT(TRIM(pv01_telefono1), ', ', TRIM(pv01_telefono_contacto)) as telefono,
                       TRIM(pv01_clabe) as banco,
                       CONCAT(TRIM(pv01_email60), ', ', TRIM(pv01_email_contacto)) as email")
                       .all

    render json: @proveedores_netmultix
  end


end