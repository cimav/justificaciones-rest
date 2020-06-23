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
    if ids.include? "901" # Admin
      @justificaciones = Justificacion.includes(:creador, :asesor).select("id, identificador, requisicion, creador_id, created_at, descripcion, asesor_id").where(created_at: 1.year.ago..1.year.after).order(created_at: :desc)
    elsif ids.include? "902" # Asesor
      @justificaciones = Justificacion.includes(:creador, :asesor).select("id, identificador, requisicion, creador_id, created_at, descripcion, asesor_id").where("asesor_id in (#{ids})").where(created_at: 1.year.ago..1.year.after).order(created_at: :desc)
    else
      @justificaciones = Justificacion.includes(:creador, :asesor).select("id, identificador, requisicion, creador_id, created_at, descripcion, asesor_id").where("creador_id in (#{ids})").where(created_at: 1.year.ago..1.year.after).order(created_at: :desc)
    end
    render json: @justificaciones, methods: [:creador_cuenta_cimav, :asesor_cuenta_cimav]

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

        if @justificacion.tipo.fraccion == 7  || @justificacion.tipo.fraccion == 5 || @justificacion.tipo.fraccion == 2
          pdf = PdfDictamen.new(@justificacion)
        else
          pdf = PdfJustificacion.new(@justificacion)
        end
        filename = "#{@justificacion.autorizo.cuenta_cimav}_#{@justificacion.requisicion}.pdf"
        send_data pdf.render, filename: filename,type: 'application/pdf', disposition: "inline"

=begin
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
=end
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

  def add_anexo
    puts "Hello >> #{params[:id]}"
    puts "Hello >> #{params[:anexos]}"

    @justificacion = Justificacion.find(params[:id])

    @justificacion.anexos += Array(params[:anexos])

    if @justificacion.save!
      head :ok
    end

  end

  def get_anexos
    @anexos = Justificacion.find(params[:justificacion_id]).anexos


    # ids = Asistente.where("asistente_id = #{params[:id]}").collect(&:creador_id).concat(Array(params[:id])).join(',')
    respond_to do |format|
      format.json do
        @anexos
      end
    end
  end

  def remove_anexo
    @justificacion = Justificacion.find(params[:id])

    idx = params[:idx].to_i

    remain_anexos = @justificacion.anexos
    if idx == 0 && @justificacion.anexos.size == 1
      @justificacion.remove_anexos!
    else
      deleted_anexo = remain_anexos.delete_at(idx)
      deleted_anexo.try(:remove!)
      @justificacion.anexos = remain_anexos
    end

    if @justificacion.save!
      head :ok
    end

    head :no_content
  end

  # POST /justificaciones
  # POST /justificaciones.json
  def create
    @justificacion = Justificacion.new(justificacion_params)

    @justificacion.fecha_cotizar = 7.days.from_now
    @justificacion.fecha_mercado = 10.days.from_now
    @justificacion.fecha_elaboracion = 13.days.from_now

    @justificacion.economica_txt = "Se efectuó una investigación de mercado para comparar precios y demás condiciones de calidad, financiamiento y oportunidad, respecto del bien requerido, dando como resultado que la persona moral propuesta, fue la que presentó las mejores condiciones en cuanto a precio, calidad, financiamiento y oportunidad, con lo cual se asegura cumplir con los preceptos del Artículo 134 de la Constitución Política de los Estados Unidos Mexicanos; así como en los Artículos 40 y 41, fracción XVII de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Público, por lo que resulta adecuado proceder a la adjudicación directa a favor del proveedor antes referido."


    @justificacion.eficaz_txt = "Mediante el procedimiento de adjudicación directa, se conseguirán las mejores condiciones disponibles para la Entidad en cuanto a precio, calidad, y oportunidad, en adición a que el Proveedor propuesto cuenta con la experiencia y capacidad idóneas para suministrar el bien requerido, y con ello se lograrán los objetivos y resultados deseados"

    @justificacion.eficiente_txt = "Con el procedimiento de adjudicación propuesto se garantizan las mejores condiciones de precio, calidad, oportunidad y demás circunstancias pertinentes debido a que se optimiza el uso y aplicación de los recursos financieros, en virtud de que esta Entidad cuenta con procesos y procedimientos claros y expeditos, con responsables y responsabilidades plenamente identificados para la contratación requerida, con lo cual se evitará la pérdida de tiempo y recursos a la Entidad."


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
      replica['created_at'] = DateTime.now
      replica['proveedor_id'] = nil
      replica['fecha_cotizar'] = 7.days.from_now
      replica['fecha_mercado'] = 10.days.from_now
      replica['fecha_elaboracion'] = 13.days.from_now
      replica['asesor_id'] = nil
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
        # pdf.render_file  "public/#{filename}"
        send_data pdf.render, filename: filename, type: 'application/pdf', disposition: "inline"
        # File.delete("public/#{filename}");
      end
    end
  end

  def mercado
    @justificacion = Justificacion.find(params[:id])
    respond_to do |format|
      format.pdf do
        filename = "Mercado_#{@justificacion.requisicion}.pdf"
        pdf = PdfMercado.new(@justificacion)
        # pdf.render_file  "public/#{filename}"
        send_data pdf.render, filename: filename, type: 'application/pdf', disposition: "inline"
        # File.delete("public/#{filename}");
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
        :economica, :eficiencia_eficacia, :lugar_entrega, :porcen_garantia, :fecha_cotizar,
        :fecha_mercado, :created_at, :status,
        :economica_txt, :eficiente, :eficiente_txt, :eficaz, :eficaz_txt,
        :acreditacion_marca,
        :proyecto_objeto, :iva_tasa,
        {anexos: []}, :idx,
        :asesor_id
      )
  end

end
