class ProyectosNetmultixController < ApplicationController

  def search

    ActiveRecord::Base.establish_connection :"production_netmultix"

    query = <<-SQL
      SELECT pr10_proyecto as proyecto, pr10_desc as objeto, TRIM(pr10_responsable) as clave, TRIM(cl01_nombre) as responsable 
      FROM pr10, cl01
      WHERE pr10_proyecto = '#{params[:proyecto].strip}' AND cl01_clave = pr10_responsable
    SQL

    proyectos = ActiveRecord::Base.connection.exec_query(query)
    if proyectos.present?
      proy = proyectos.first
      # requisicion['descripcion']  = proyectos.collect{|d| d['descripcion']}.join("\n")
      render json: proy, status: :ok
    else
      render json:  nil, status: :ok
    end

    # ActiveRecord::Base.connection.close

  end
end