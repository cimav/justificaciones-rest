class ProveedorNetmultix < ActiveRecord::Base

  establish_connection :"production_netmultix"
  self.table_name = "pv01"

  self.abstract_class = true

end