class EmpleadosController  < ApplicationController

  def index
    @empleados = Empleado.all.order(:nombre)
    render json: @empleados, status: :ok
  end

  def show
  end

  def cuenta
    # @empleado = Empleado.find_by_cuenta_cimav(params[:cuenta_cimav]) # where("cuenta_cimav like '%#{params[:cuenta_cimav]}%'").first
    @empleado = Empleado.where("cuenta_cimav like '%#{params[:cuenta_cimav]}%'").first rescue '{}'
    render json: @empleado, status: :ok
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def empleado_params
    params.require(:persona).permit(:id, :tipo, :clave, :nombre, :sede, :cuenta_cimav)
  end

end