class PdfMercado < Prawn::Document

  def initialize(justificacion)
    super()

    @justificacion =  justificacion

    #stroke_axis

    direccion_cimav = "Miguel de Cervantes 120, Complejo Industrial Chihuahua\nChihuahua, Chih. México. C.P. 31136"

=begin
    font_families.update("Arial" => {
        :normal => "public/assets/fonts/Arial.ttf",
        :italic => "public/assets/fonts/Arial Italic.ttf",
        :bold => "public/assets/fonts/Arial Bold.ttf",
        :bold_italic => "public/assets/fonts/Arial Bold Italic.ttf"
    })
    font "Arial"
=end
    image "public/logo-cimav.png", :at=>[bounds.left, bounds.top+2], :scale=>0.90

    move_down 10
    text 'Centro de Investigación en Materiales Avanzados S. C.', size: 16, style: :normal, align: :center

    stroke do
      move_down 8
      stroke_color 'b3b3b3'
      stroke_horizontal_rule
    end

    draw_text 'FECHA ELABORACIÓN:', size: 11, style: :bold, :at=>[220, 660]
    draw_text fecha(justificacion.fecha_mercado) , size: 12, style: :bold, :at=>[400, 660]
    stroke do
      move_down 8
      stroke_color 'b3b3b3'
      horizontal_line 350, bounds.right, :at=>658
    end

    draw_text 'ASUNTO: ESTUDIO DE MERCADO', size: 11, style: :bold, :at=>[300, 640]

    row=620
    draw_text :"No. Partida / CUCOP",  style: :bold,size: 11, :at=>[0,row-=14]
    move_down 74
    indent(10) do
      text "#{justificacion.partida.texto.upcase}",  size: 11
    end
    row = cursor
    draw_text :"No. Requisición",  style: :bold,size: 11, :at=>[0,row-=20]
    draw_text :"#{justificacion.requisicion}",  size: 11, :at=>[10,row-=14]
    draw_text :"Descripción",  style: :bold,size: 11, :at=>[0,row-=20]
    move_down 64
    indent(10) do
      text "#{justificacion.descripcion}",  size: 11, align: :justify
    end

    # move_down 14
    row = cursor
    draw_text "Proveedores",  style: :bold, size: 11, :at=>[20,row-=14]
    move_down 16
    indent(10) do
      idx = 0
      justificacion.proveedores.map do |provee|
        idx = idx + 1
        row = cursor
        draw_text :"#{idx}) #{provee.razon_social.upcase}",  style: :bold, size: 11, :at=>[20,row-=14]
        indent(10) do
          draw_text :"Precio:",  size: 11, :at=>[20,row-=14]
          draw_text :"#{monto_to_currency(provee.monto, provee)}",  size: 11, :at=>[56,row]
          draw_text :"Origen del bien:",  size: 11, :at=>[164,row]
          draw_text :"#{provee.es_nacional ? "Nacional" : "Extranjero"}",  size: 11, :at=>[238,row]
          draw_text :"Fuente de consulta:",  size: 11, :at=>[340,row]
          fuente = provee.fuente==0?"Internet":(provee.fuente==1?"Compranet":"Presencial")
          draw_text :"#{fuente}",  size: 11, :at=>[430,row]
          draw_text "Cumplimiento de condiciones técnicas:", size: 11, :at=>[20,row-=20]
          move_cursor_to row - 6
          indent(30) do text "#{provee.cumple_tecnicas}",  size: 11, align: :justify end
          move_down 5
          indent(20) do text "Cantidad que puede surtir:", size: 11 end
          indent(30) do text "#{provee.cantidad_surtir}",  size: 11,align: :justify end
        end
      end
    end

    move_down 30
    text "ELABORÓ", style: :bold, align: :center, size: 11, character_spacing: 0.30
    # text justificacion.elaboro.nombre+"\n"+justificacion.autoriza_cargo.upcase, align: :center, size: 11, character_spacing: 0.30
    text justificacion.elaboro.nombre, align: :center, size: 11, character_spacing: 0.30

    repeat :all do
      move_down 20
      bounding_box [bounds.left, bounds.bottom + 25], :width  => bounds.width do
        move_down 15
        text "FO-CON-05", :size => 8, align: :right
      end
    end


  end

  def fecha(_fecha)
    "#{_fecha.strftime('%d')} de #{get_month_name(_fecha.strftime('%m').to_i)} de #{_fecha.strftime('%Y')}"
  end

  def get_month_name(number)
    months = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"]
    name = months[number - 1]
    return name
  end

  def monto_to_currency(monto, proveedor)
    ActionController::Base.helpers.number_to_currency(monto, :unit => proveedor.moneda.simbolo) + " " +  proveedor.moneda.code
  end

  def si_no(value)
    value ? 'Si' : 'No'
  end

end
