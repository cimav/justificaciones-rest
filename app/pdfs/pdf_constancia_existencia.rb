class PdfConstanciaExistencia < Prawn::Document

  def initialize(requisiciones)
    super(:page_layout => :landscape, :page_size => "A4")

    # stroke_axis

    direccion_cimav = "Miguel de Cervantes 120, Complejo Industrial Chihuahua\nChihuahua, Chih. México. C.P. 31136"

    self.font_families.update("Arial" => {
        normal: Rails.root.join("public/assets/fonts/Arial.ttf"),
        italic: Rails.root.join("public/assets/fonts/Arial-Italic.ttf"),
        bold: Rails.root.join("public/assets/fonts/Arial-Bold.ttf"),
        bold_italic: Rails.root.join("public/assets/fonts/Arial-Bold-Italic.ttf")
    })
    font "Arial"

    image "#{Rails.root}/public/logo-cimav.png", at: [bounds.left, bounds.top+2], scale: 0.90

    move_down 10
    text 'Centro de Investigación en Materiales Avanzados S. C.', size: 16, style: :normal, align: :center

    requi_first = requisiciones.first rescue nil
    if !requi_first.present?
      move_down 12
      text 'No se encontró requisición', size: 16, style: :normal, align: :center
    else
      begin
        move_down 14
        text 'Constancia de Existencia', size: 16, style: :bold, align: :center
        move_down 4
        text "Núm. Requisición: #{requi_first['requisicion']}", size: 11, style: :normal
        fecha_req = fecha(Date.parse requi_first['fecha_requisicion'].to_s) rescue 'Falla'
        text "Fecha Requisición: #{fecha_req}", size: 11, style: :normal

        move_down 10
        data = [[
          {:content => '<b>Partida</b>',:inline_format => true, align: :center,size: 8, :borders => [:bottom], :border_color => "b3b3b3"},
          {:content => '<b>Unidad</b>',:inline_format => true, align: :center,size: 8, :borders => [:bottom], :border_color => "b3b3b3"},
          {:content => '<b>Cant.</b>',:inline_format => true, align: :center, size: 8, :borders => [:bottom], :border_color => "b3b3b3"},
          {:content => '<b>Descripción</b>',:inline_format => true, align: :center, size: 8, :borders => [:bottom], :border_color => "b3b3b3"},
          {:content => '<b>Existencia</b>',:inline_format => true, align: :center, size: 8, :borders => [:bottom], :border_color => "b3b3b3"},
          {:content => '<b>Entrada</b>',:inline_format => true, align: :center, size: 8, :borders => [:bottom], :border_color => "b3b3b3"},
          {:content => '<b>Disponible</b>',:inline_format => true, align: :center, size: 8, :borders => [:bottom], :border_color => "b3b3b3"},
          {:content => '<b>Bienes</b>',:inline_format => true, align: :center, size: 8, :borders => [:bottom], :border_color => "b3b3b3"},
          {:content => '<b>Observaciones</b>',:inline_format => true, align: :center, size: 8, :borders => [:bottom], :border_color => "b3b3b3"},
          {:content => '<b>Rotación</b>',:inline_format => true, align: :center, size: 8, :borders => [:bottom], :border_color => "b3b3b3"}
        ]]
        # data = [[celda1, celda2, celda3, celda4, celda5, celda6, celda]]
        requisiciones.map do |requi|
          data.push([
            {:content => "#{requi['partida']}", size: 8, :borders => [:left, :right, :top, :bottom], :border_color => "b3b3b3", :inline_format => true, :padding => 2},
            {:content => "#{requi['unidad']}", size: 8, :borders => [:left, :right, :top, :bottom], :border_color => "b3b3b3", :inline_format => true, :padding => 2},
            {:content => "#{requi['cantidad']}", size: 8, :borders => [:left, :right, :top, :bottom], :border_color => "b3b3b3", :inline_format => true, :padding => 2},
            {:content => "#{requi['descripcion']}", size: 8, :borders => [:left, :right, :top, :bottom], :border_color => "b3b3b3", :inline_format => true, :padding => 2},
            {:content => "", size: 8, :borders => [:left, :right, :top, :bottom], :border_color => "b3b3b3", :inline_format => true, :padding => 2},
            {:content => "", size: 8, :borders => [:left, :right, :top, :bottom], :border_color => "b3b3b3", :inline_format => true, :padding => 2},
            {:content => "", size: 8, :borders => [:left, :right, :top, :bottom], :border_color => "b3b3b3", :inline_format => true, :padding => 2},
            {:content => "", size: 8, :borders => [:left, :right, :top, :bottom], :border_color => "b3b3b3", :inline_format => true, :padding => 2},
            {:content => "", size: 8, :borders => [:left, :right, :top, :bottom], :border_color => "b3b3b3", :inline_format => true, :padding => 2},
            {:content => "", size: 8, :borders => [:left, :right, :top, :bottom], :border_color => "b3b3b3", :inline_format => true, :padding => 2}
        ])
          # data.push([celda0, celda0, celda1, celda2, celda3, celda4])
        end
        table(data, :column_widths => [40, 40, 40, 250, 60, 50, 50, 50, 134, 55])

        if cursor < 80
          start_new_page
        end

        row = 80
        draw_text :"#{requi_first['solicitante']}", size: 11, :at=>[40, row]
        row -= 15
        draw_text :"Solicitante", size: 11, :at=>[80, row]
        draw_text :"Responsable almacén", size: 11, :at=>[500, row]
        row -= 20
        draw_text :"NOTA: Esta constancia, sólo es válida con el sello del almacén.", size: 9, :at=>[0, row]
        row -= 14
        draw_text :"OBJETIVO: Garantizar que el área requirente verificó en el almacen el nivel de existencia de los bienes que requiere y en su caso justificar la adquisición de los mismos como resultado de", size: 9, :at=>[0, row]
        row -= 10
        draw_text :"las estrategias determinadas por la dependencia o entidad para el adecuado control de los inventarios (artículo 27 del Reglamento de la Ley de Adquisiciones, Arrendamientos y Servicios", size: 9, :at=>[0, row]
        row -= 10
        draw_text :"del Sector Público).", size: 9, :at=>[0, row]

      rescue StandardError => e
        print e
      end
    end

    repeat :all do
      move_down 20
      bounding_box [bounds.left, bounds.bottom + 23], width: bounds.width do
        move_down 15
        text "FO-CON-02", size: 8, align: :right
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
    ActionController::Base.helpers.number_to_currency(monto, unit: proveedor.moneda.simbolo) + " " + proveedor.moneda.code
  end


end