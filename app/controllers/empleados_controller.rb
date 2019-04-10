class EmpleadosController  < ApplicationController

  def index
    @empleados = Empleado.all.order(:nombre)
    render json: @empleados, status: :ok
  end

  def show
  end

  def cuenta
    # @empleado = Empleado.find_by_cuenta_cimav(params[:cuenta_cimav]) # where("cuenta_cimav like '%#{params[:cuenta_cimav]}%'").first
    cuenta_cimav = params[:cuenta_cimav]
    if cuenta_cimav == 'ion'
      cuenta_cimav = 'jonathan.hernandez'
    end
    @empleado = Empleado.where("cuenta_cimav like '#{cuenta_cimav}'").first rescue '{}'
    if @empleado
      asistentes =  Asistente.where("asistente_id = #{@empleado.id}")
      @empleado.is_asistente = asistentes.length > 0
      @empleado.is_admin = asistentes.any? {|h| h['creador_id'] == 999}
      # Asistente.where("asistente_id = #{@empleado.id} AND creador_id = 999").length > 0
    end
    render json: @empleado, status: :ok
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def empleado_params
    params.require(:persona).permit(:id, :tipo, :clave, :nombre, :sede, :cuenta_cimav, :is_admin, :is_asistente)
  end

end