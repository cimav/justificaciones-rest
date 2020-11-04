class RequisicionesNetmultixController < ApplicationController

  def search

    ActiveRecord::Base.establish_connection :"production_netmultix"

    query = <<-SQL
      SELECT CO01_REQUISICION as requisicion, CAST(CO01_CVE_RESPONSABLE as unsigned) as cve_responsable, CO01_FECHA_REQ as fecha_requisicion, 
            CAST(CO01_SOLICITANTE as unsigned) as cve_solicitante, CO01_STATUS as req_status, CAST(CO01_USUARIO  as unsigned) as cve_creador,
             CO02_PARTIDA as partida, REPLACE(CO02_DESC_LARGA, '. | ', '') as descripcion, CO02_RENGLON as renglon, CO02_PROYECTO as proyecto, CO02_STATUS as renglo_status,
            co02_unidad as unidad, co02_cant_req as cantidad
            FROM co01, co02 WHERE CO01_REQUISICION = '#{params[:requisicion].strip}' AND CO01_REQUISICION = CO02_REQUISICION
    SQL

    # AND CO01_STATUS > 0 and CO01_FECHA_REQ > '20170101';

    requisiciones = ActiveRecord::Base.connection.exec_query(query)
    if requisiciones.present?
      requisicion = requisiciones.first
      requisicion['descripcion']  = requisiciones.collect{|d| "#{d['unidad']} #{d['cantidad']} #{d['descripcion']}"}.join("\n")
      render json: requisicion
    else
      render json:  nil, status: :ok
    end

    # ActiveRecord::Base.connection.close

  end

  def constancia_existencia

    ActiveRecord::Base.establish_connection :"production_netmultix"

    query = <<-SQL
      SELECT CO01_REQUISICION as requisicion, CAST(CO01_CVE_RESPONSABLE as unsigned) as cve_responsable, CO01_FECHA_REQ as fecha_requisicion, 
            CAST(CO01_SOLICITANTE as unsigned) as cve_solicitante, CO01_STATUS as req_status, CAST(CO01_USUARIO  as unsigned) as cve_creador,
             CO02_PARTIDA as partida, REPLACE(CO02_DESC_LARGA, '. | ', '') as descripcion, CO02_RENGLON as renglon, CO02_PROYECTO as proyecto, CO02_STATUS as renglo_status,
            co02_unidad as unidad, co02_cant_req as cantidad,
            no01_nom_emp as solicitante, '#{params[:responsable].strip}' as responsable
            FROM co01, co02, no01 WHERE CO01_REQUISICION = '#{params[:requisicion].strip}' AND CO01_REQUISICION = CO02_REQUISICION AND no01.no01_cve_emp = CO01_CVE_RESPONSABLE
    SQL

    requisiciones = ActiveRecord::Base.connection.exec_query(query)

    respond_to do |format|
      format.pdf do
        req_id = requisiciones.first['requisicion'] rescue '0000'
        filename = "ConstanciaExistencia#{req_id}.pdf"
        pdf = PdfConstanciaExistencia.new(requisiciones)
        send_data pdf.render, filename: filename, type: 'application/pdf', disposition: 'inline'
      end
    end
  end


end