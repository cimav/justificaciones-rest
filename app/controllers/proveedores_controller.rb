class ProveedoresController < ApplicationController

  def index
    proveedores = Proveedor.all rescue '{}'
    render json: proveedores, status: :ok
  end

  def by_justificacion
    proveedores = Proveedor.where("justificacion_id = #{params[:justificacion_id]}")
    render json: proveedores, status: :ok
  end

  def show
    proveedor = Proveedor.find(params[:id])
    render json: proveedor, status: :ok, location: proveedor
  end

  def create
    proveedor = Proveedor.new(proveedor_params)
    if proveedor.save!
      render json: proveedor, status: :created
    else
      render json: proveedor.errors, status: :unprocessable_entity
    end
  end

  def update
    proveedor = Proveedor.find(params[:id])
    if proveedor.update(proveedor_params)
      render json: proveedor, status: :ok, location: proveedor
    else
      render json: proveedor.errors, status: :unprocessable_entity
    end
  end

  def destroy
    proveedor = Proveedor.find(params[:id])
    proveedor.destroy
    head :no_content
  end

  def proveedor_params
    params.require(:proveedor).permit(:id, :razon_social, :rfc, :clave, :justificacion_id, :es_nacional, :fuente, :domicilio,
                                      :contacto, :telefono, :email, :banco, :cumple_tecnicas, :cantidad_surtir, :monto)
  end

end