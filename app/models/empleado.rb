class Empleado < ActiveRecord::Base

  establish_connection :"production_cimavnetmultix"
  self.table_name = "#{self.connection.current_database}.personas"

  self.abstract_class = true

end