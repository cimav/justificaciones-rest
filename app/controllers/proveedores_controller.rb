class ProveedoresController < ApplicationController

  def index
    proveedores = Proveedor.all rescue '{}'
    render json: proveedores, status: :ok
  end

  def by_justificacion
    @proveedores = Proveedor.where("justificacion_id = #{params[:justificacion_id]}")
    # render json: proveedores, status: :ok
    respond_to do |format|
      format.json do
        @proveedores
      end
    end
  end

  def show
    @proveedor = Proveedor.find(params[:id])
    respond_to do |format|
      format.json do
        @proveedor
      end
    end
    #render json: @proveedor, status: :ok, location: @proveedor
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

  def send_focon04

    proveedor = Proveedor.find(params[:id])
    justificacion = Justificacion.find(params[:justificacion_id])

    begin
      mail = ProveedorMailer.send_focon04(proveedor, justificacion).deliver_later
      puts "Delivered mail => #{mail}"
    rescue StandardError => e
      puts "Delivery error => #{e}"
    end

    render json: proveedor, status: :ok, location: proveedor

  end

  def proveedor_params
    params.require(:proveedor).permit(:id, :razon_social, :rfc, :clave, :justificacion_id, :es_nacional, :fuente, :domicilio,
                                      :contacto, :telefono, :email, :banco, :cumple_tecnicas, :cantidad_surtir, :monto, :moneda_id)
  end

end
