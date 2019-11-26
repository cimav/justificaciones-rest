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
      @justificaciones = Justificacion.includes(:creador).select("id, identificador, requisicion, creador_id, created_at, descripcion").where(created_at: 1.year.ago..Time.now)
    else
      @justificaciones = Justificacion.includes(:creador).select("id, identificador, requisicion, creador_id, created_at, descripcion").where("creador_id in (#{ids})").where(created_at: 1.year.ago..Time.now) #.order(:requisicion)
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

        if @justificacion.tipo.fraccion == 7 || @justificacion.tipo.fraccion == 5
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

  # POST /justificaciones
  # POST /justificaciones.json
  def create
    @justificacion = Justificacion.new(justificacion_params)

    @justificacion.fecha_cotizar = 7.days.from_now
    @justificacion.fecha_mercado = 10.days.from_now
    @justificacion.fecha_elaboracion = 13.days.from_now

    @justificacion.economica_txt = 'Con la Investigación de Mercado se establecieron precios y demás condiciones de calidad, '+
        "financiamiento y oportunidad, respecto de los bienes o servicios requeridos, con lo cual "+
        'se asegura cumplir con los principios del artículo 134 de la Constitución Política de los Estados '+
        'Unidos Mexicanos y de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Público, '+
        'en cuanto a precio, calidad, financiamiento, oportunidad y demás circunstancias pertinentes, por '+
        'lo que el procedimiento de adjudicación directa permite en contraposición al procedimiento de '+
        "licitación pública, obtener con mayor oportunidad los bienes o servicios requeridos al "+
        'menor costo económico para el CIMAV, S.C. según lo detallado en la investigación de mercado '+
        'que se realizó, generando ahorro de recursos por estar proponiendo la adjudicación al '+
        'proveedor único cuya propuesta se considera aceptable en cuanto a su solvencia. '+
        'Lo anterior de acuerdo con lo establecido en el numeral 4.2.4 (ADJUDICACIÓN DIRECTA) y '+
        'numeral 4.2.4.1.1 (Verificar Acreditamiento de Excepción) del Acuerdo por el que se modifica el '+
        'Manual Administrativo de Aplicación General en Materia de Adquisiciones, Arrendamientos y '+
        'Servicios del Sector Público, publicado en el Diario Oficial de la Federación el 21 de noviembre '+
        'de 2012.'
    @justificacion.eficaz_txt = 'Con el procedimiento de contratación por adjudicación directa, se logrará obtener con '+
        "oportunidad los bienes o servicios atendiendo a las características requeridas en "+
        'contraposición con el procedimiento de licitación pública, dado que se reducen tiempos y se '+
        'generan economías; aunado a que la persona propuesta cuenta con experiencia y capacidad '+
        'para satisfacer las necesidades requeridas, además de que es el único que ofrece las mejores '+
        'condiciones disponibles en cuanto a precio, calidad y oportunidad, con lo que se lograría el '+
        'cumplimiento de los objetivos y resultados deseados en el tiempo requerido, situación que se '+
        'puede demostrar en base a la investigación de mercado. Lo anterior de acuerdo con lo establecido '+
        'en el numeral 4.2.4 (ADJUDICACIÓN DIRECTA) y numeral 4.2.4.1.1 (Verificar Acreditamiento de '+
        'Excepción) del Acuerdo por el que se modifica el Manual Administrativo de Aplicación General '+
        'en Materia de Adquisiciones, Arrendamientos y Servicios del Sector Público, publicado en el '+
        'Diario Oficial de la Federación el 21 de noviembre de 2012.'
    @justificacion.eficiente_txt = 'Con el procedimiento de adjudicación directa, a diferencia del procedimiento de licitación '+
        'pública, se logra el uso racional de recursos con los que cuenta la Entidad para realizar la '+
        'contratación, obteniendo las mejores condiciones de precio, calidad y oportunidad, evitando la '+
        'pérdida de tiempo y recursos al Estado, lo cual se demuestra con la investigación de mercado que'+
        'se realizó, quedando evidencia de su resultado ya que los recursos disponibles con los que cuenta '+
        'el CIMAV se aplican conforme a los lineamientos de racionalidad y austeridad presupuestaria. Lo '+
        'anterior de acuerdo con lo establecido en el numeral 4.2.4 (ADJUDICACIÓN DIRECTA) y numeral '+
        '4.2.4.1.1 (Verificar Acreditamiento de Excepción) del Acuerdo por el que se modifica el Manual '+
        ' Administrativo de Aplicación General en Materia de Adquisiciones, Arrendamientos y Servicios del '+
        ' Sector Público, publicado en el Diario Oficial de la Federación el 21 de noviembre de 2012.'

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
        :acreditacion_marca

      )
  end

end