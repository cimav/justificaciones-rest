#!/bin/env ruby
# encoding: utf-8

class JustificacionesController  < ApplicationController
  # before_action :set_justificacion, only: [:show, :edit, :update, :destroy]

  # GET /justificaciones
  # GET /justificaciones.json
  def index
    @justificaciones = Justificacion.all
  end

  def all_by_creador

    ids = Asistente.where("asistente_id = #{params[:id]}").collect(&:creador_id).concat(Array(params[:id])).join(',')
    # @justificaciones = Justificacion.where("creador_id = #{params[:id]}")
    if ids.include? "999"
      @justificaciones = Justificacion.includes(:creador).all
    else
      @justificaciones = Justificacion.includes(:creador).where("creador_id in (#{ids})") #.order(:requisicion)
    end
    render json: @justificaciones, methods: [:creador_cuenta_cimav]

  end

  def show
    @justificacion = Justificacion.find(params[:id])
    respond_to do |format|
      format.json do
        @justificacion
      end
      format.pdf do

=begin
        filename = "#{@justificacion.autorizo.cuenta_cimav}_#{@justificacion.requisicion}.pdf"
        pdf = Prawn::Document.new
        pdf.text "Hello There"
        send_data pdf.render,  type: 'application/pdf', disposition: "inline"
=end
# =begin
        filename = "#{@justificacion.autorizo.cuenta_cimav}_#{@justificacion.requisicion}.pdf"
        # if @justificacion.tipo.fraccion == 1 ||  @justificacion.tipo.fraccion == 7
        if @justificacion.tipo.fraccion == 7
          pdf = PdfDictamen.new(@justificacion)
        else
          pdf = PdfJustificacion.new(@justificacion)
        end
        pdf.render_file  "public/#{filename}"
        send_data pdf.render,
                  filename: filename,
                  type: 'application/pdf',
                  disposition: "inline"
        File.delete("public/#{filename}")
# =end

      end
    end
  end

  # GET /justificaciones/new
  def new
    @justificacion = Justificacion.new
  end

  # GET /justificaciones/1/edit
  def edit

  end

  # POST /justificaciones
  # POST /justificaciones.json
  def create
    @justificacion = Justificacion.new(justificacion_params)
    if @justificacion.save!
      render json: @justificacion, status: :created
    else
      render json: @justificacion.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /justificaciones/1
  # PATCH/PUT /justificaciones/1.json
  def update

    @justificacion = Justificacion.find(params[:id])  rescue '{}'
    if @justificacion.update(justificacion_params)
      render :show, status: :ok, location: @justificacion
    else
      render json: @justificacion.errors, status: :unprocessable_entity
    end
  end

  def replicar
    identificador = params[:identificador]
    origen = Justificacion.find(params[:id])
    if origen
      replica = origen.attributes
      replica['id'] = nil
      replica['identificador'] = identificador
      replica['proveedor_id'] = nil
          replica = Justificacion.new(replica)
      if replica.save!
        origen.proveedores.each do |prov_origen|
          prov_replica = prov_origen.attributes
          prov_replica['id'] = nil
          prov_replica['justificacion_id'] = replica.id
          prov_replica = Proveedor.new(prov_replica)
          prov_replica.save!
        end
        # replica = Justificacion.find(params[:id])
        render json: replica, status: :ok
      else
        render json: replica.errors, status: :unprocessable_entity
      end
    else
      render json: replica.errors, status: :unprocessable_entity
    end
  end

  # DELETE /justificaciones/1
  # DELETE /justificaciones/1.json
  def destroy
    @justificacion = Justificacion.find(params[:id])
    @justificacion.destroy
    head :no_content
  end

  def cotizacion
    @justificacion = Justificacion.find(params[:id])
    respond_to do |format|
      format.pdf do
        filename = "Cotizacion_#{@justificacion.requisicion}.pdf"
        pdf = PdfCotizacion.new(@justificacion, params[:num_provee])
        pdf.render_file  "public/#{filename}"
        send_data pdf.render,
                  filename: filename,
                  type: 'application/pdf',
                  disposition: "inline"
        File.delete("public/#{filename}");
      end
    end
  end

  def mercado
    @justificacion = Justificacion.find(params[:id])
    respond_to do |format|
      format.pdf do
        filename = "Mercado_#{@justificacion.requisicion}.pdf"
        pdf = PdfMercado.new(@justificacion)
        pdf.render_file  "public/#{filename}"
        send_data pdf.render,
                  filename: filename,
                  type: 'application/pdf',
                  disposition: "inline"
        File.delete("public/#{filename}");
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  #def set_justificacion
  #  @justificacion = Justificacion.find(params[:id])
  #end

  # Never trust parameters from the scary internet, only allow the white list through.
  def justificacion_params
    params.require(:justificacion).permit(:id,
        :creador_id, :tipo_id, :elaboro_id, :autorizo_id,
        :proveedor_id,
        :moneda_id, :requisicion, :identificador, :proyecto, :bien_servicio,
        :subtotal, :iva, :importe, :condiciones_pago, :razon_compra, :terminos_entrega, :plazo,
        :fecha_inicio, :fecha_termino, :fecha_elaboracion, :descripcion,
        :num_pagos, :porcen_anticipo, :autoriza_cargo, :forma_pago,
        :num_dias_plazo, :motivo_seleccion, :identificador, :partida_id,
        :economica, :eficiencia_eficacia, :lugar_entrega, :porcen_garantia, :fecha_cotizar
      )
  end

end