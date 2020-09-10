#!/bin/env ruby
# encoding: utf-8

class PdfCotizacion < Prawn::Document

  def initialize(justificacion, provee_id)
    super()

    Prawn::Font::AFM.hide_m17n_warning = true

    proveedor = Proveedor.find(provee_id)

    case justificacion.creador.sede
    when 2
      direccion_cimav = "Calle CIMAV #110,\n Ejido Arroyo Seco\nDurango, Dgo. México. C.P. 34147"
      email_acuse = "jorge.parra@cimav.edu.mx"
    when 3
      direccion_cimav = "Alianza Norte 202,\n Parque de Investigación e Innovación Tecnológica\nApodaca, Nuevo León, México. C.P. 66600"
      email_acuse = "alberto.lara@cimav.edu.mx"
    when 4
      direccion_cimav = "Paseo Triunfo de la República 3340,\n Edificio Atlantis, tercer piso\nCd. Juárez, Chihuahua, México. C.P. 32330"
      email_acuse = "jorge.parra@cimav.edu.mx"
    else
      direccion_cimav = "Miguel de Cervantes 120,\n Complejo Industrial Chihuahua\nChihuahua, Chih. México. C.P. 31136"
      email_acuse = "jorge.parra@cimav.edu.mx"
    end

    font_families.update("Arial" => {
        :normal => "public/assets/fonts/Arial.ttf",
        :italic => "public/assets/fonts/Arial Italic.ttf",
        :bold => "public/assets/fonts/Arial Bold.ttf",
        :bold_italic => "public/assets/fonts/Arial Bold Italic.ttf"
    })
    font "Arial"

    image "public/logo-cimav.png", :at=>[bounds.left, bounds.top+2], :scale=>0.90

    move_down 10

    text 'Centro de Investigación en Materiales Avanzados S. C.', size: 16, style: :normal, align: :center

    stroke do
      move_down 8
      stroke_color 'b3b3b3'
      stroke_horizontal_rule
    end

    draw_text 'FECHA:', size: 11, style: :bold, :at=>[300, 660]
    draw_text fecha(justificacion.created_at) , size: 12, style: :bold, :at=>[400, 660]
    stroke do
      move_down 8
      stroke_color 'b3b3b3'
      horizontal_line 350, bounds.right, :at=>658
    end

    draw_text 'ASUNTO: SOLICITUD DE COTIZACIÓN', size: 11, style: :bold, :at=>[300, 640]

    draw_text :"A quien corresponda:", size: 11, :at=>[0,610]
    draw_text :"#{proveedor.razon_social}" , style: :bold, size: 11, :at=>[0, 595]
    draw_text :"#{proveedor.domicilio}" , size: 11, :at=>[0, 580]

=begin
Por lo antes mencionado y con el objeto de conocer: a).- la existencia bienes, arrendamientos o servicios a requerir \f
en las condiciones que se indican; b).- posibles proveedores a nivel nacional o internacional; c).- el precio estimado \f
de lo requerido, y d).- la capacidad de cumplimiento de los requisitos de participación, nos permitimos solicitar su \f
valioso apoyo a efecto de proporcionarnos la cotización de los bienes y/o servicios y/o arrendamientos \f
descritos en el documento anexo (poner en el anexo la descripción con las especificaciones técnicas y requisitos de \f
calidad, cantidad y oportunidad del o los bienes, arrendamiento y/o servicios a contratar).
=end

    move_down 120
    txt = "El <b>Cimav</b>, como Centro de Investigación del Gobierno Federal, requiere para sus actividades de suministro, \f
arrendamiento y/o prestación de servicios, mismas que se encuentran reguladas por la Ley de Adquisiciones, Arrendamientos \f
y Servicios del Sector Público (LAASSP) y su Reglamento, obtener información para contratar bajo las mejores condiciones disponibles para el Estado.

En este sentido y en terminos de lo previsto en el artículo 2 fracción X de la LAASSP, su representada ha sido identificada \f
por este ente público, como un posible prestador de servicio y/o proveedor.

Por lo antes mencionado y con el objeto de conocer: a).- la existencia bienes, arrendamientos o servicios a requerir \f
en las condiciones que se indican; b).- posibles proveedores a nivel nacional o internacional; c).- el precio estimado \f
de lo requerido, y d).- la capacidad de cumplimiento de los requisitos de participación, nos permitimos solicitar su \f
valioso apoyo a efecto de proporcionarnos la cotización de los bienes y/o servicios y/o arrendamientos \f
descritos en la última hoja de este documento y/o en el o los documentos anexos.

Dicha cotización se requiere que la remita en documento de la empresa, debidamente firmada por persona facultada, \f
a la siguiente dirección:

<i>#{direccion_cimav}</i>

Y que sea dirigida a nombre de: <b>#{justificacion.elaboro.nombre}</b>.

Mucho agradeceré que en su respuesta se incluya: <i>Lugar y fecha de cotización y vigencia de la misma.</i>

Para el caso de dudas, comentarios y/o aclaraciones, remitirlas al correo: <b>#{justificacion.elaboro.cuenta_cimav}@cimav.edu.mx</b>

La fecha límite para presentar la cotización es el: <b>#{fecha(justificacion.fecha_cotizar)}</b>

Favor de enviar acuse de recibo de esta solicitud al correo electrónico a: <b>#{email_acuse}</b>

<b>NOTA</b>: Vencido el plazo de recepción de cotizaciones, el <b>Cimav</b> con fundamento en lo previsto en el artículo 26 de la LAASSP, \f
se definirá el procedimiento a seguir para la contratación, el cual puede ser: LICITACIÓN PÚBLICA, INVITACIÓN A CUANDO MENOS \f
TRES PERSONAS y/o ADJUDICACIÓN DIRECTA, mismo que se informará a las personas que presentaron su cotización.

Este documento no genera obligación alguna para el centro."

    txt = txt.gsub(/\f\n/, '')
    text txt,size: 11, :align=>:justify, :inline_format => true

    txt = "\n(Para efectos de control interno, en el caso de no recibir respuesta o manifestar un inconveniente o imposibilidad, se \f
procederá a hacer la anotación respectiva en nuestros registros, circunstancias que deberán ser consideradas al momento de definir el \f
tipo de procedimiento de contratación)"

    txt = txt.gsub(/\f\n/, '')
    text txt,size: 10, style: :italic,:align=>:justify


    start_new_page

    image "public/logo-cimav.png", :at=>[bounds.left, bounds.top+2], :scale=>0.90

    move_down 10
    text 'Centro de Investigación en Materiales Avanzados S. C.', size: 16, style: :normal, align: :center

    stroke do
      move_down 8
      stroke_color 'b3b3b3'
      stroke_horizontal_rule
    end

    move_down 10
    txt = "PARA FORMULAR SU COTIZACIÓN, SE DEBERA CONSIDERAR LOS SIGUIENTES ASPECTOS:"
    text txt, style: :bold

    move_down 8
    txt = "Datos que en su caso, se deben proporcionar para que el destinatario de la solicitud conteste:"
    text txt, style: :bold

    move_down 8
    indent(20) do
      txt =
        "1.- Los datos de los bienes, arrendamientos o servicios a cotizar los cuales se especifican en el anexo.

        2.- Condiciones de entrega:
        En una sola exhibición de #{justificacion.num_dias_plazo} días naturales posteriores a la recepción de la orden de compra."

        text txt
    end
    indent(40) do
      txt =
          "o Entregas parciales con una vigencia máxima (fechas o plazo):  #{fecha(justificacion.fecha_termino)}
          o El lugar de entrega será: #{justificacion.lugar_entrega}"
      text txt
    end
=begin
    stroke do
      stroke_color 'b3b3b3'
      horizontal_line 348, bounds.right, :at=>550
    end
    stroke do
      stroke_color 'b3b3b3'
      horizontal_line 165, bounds.right, :at=>536
    end
=end

    indent(20) do
      txt ="
      3.- Considerar en su cotización que el pago es a los 20 días naturales posteriores a la entrega de la factura, previa entrega de los bienes o prestación de los servicios a satisfacción.

      4.- Señalar en su caso, el porcentaje del anticipo: #{justificacion.porcen_anticipo}

      5.- El porcentaje de garantía de cumplimiento será del #{justificacion.porcen_garantia}%.

      6.- Penas convencionales por atraso en la entrega de bienes y/o servicios y Deducciones por incumplimiento parcial o deficiente serán del 0.1% diario.

      7.- En su caso, los métodos de prueba que empleará el ente público para determinar el cumplimiento de las especificaciones solicitadas."

      text txt
    end
    indent(40) do
      txt =
          "o Normas que deben de cumplirse.
          o Registros Sanitarios o Permisos Especiales, en su caso."
      text txt
    end

    indent(20) do
      txt ="
      8.- Origen de los bienes (nacional o país de importación) y nacionalidad de los posibles proveedores.

      9.- En caso de bienes de importación la moneda en que cotiza.

      10.- En caso de que el proceso de fabricación de los bienes requeridos sea superior a 60 días, señale el tiempo que correspondería a su producción.

      11.- En su caso, especificar si el costo incluye:"
      text txt
    end

    indent(40) do
      txt ="o Instalación.
          o Capacitación.
          o Puesta en marcha."
      text txt
    end

    indent(20) do
      txt = "
      12.- Otras garantías que se debe considerar, indicar el o los tipos de garantía, o de responsabilidad civil señalando su vigencia."
      text txt
    end

    repeat :all do
      move_down 20
      bounding_box [bounds.left, bounds.bottom + 25], :width  => bounds.width do
        move_down 15
        text "FO-CON-04", :size => 8, align: :right
      end
    end

    start_new_page


    image "public/logo-cimav.png", :at=>[bounds.left, bounds.top+2], :scale=>0.90

    move_down 10
    text 'Centro de Investigación en Materiales Avanzados S. C.', size: 16, style: :normal, align: :center

    stroke do
      move_down 8
      stroke_color 'b3b3b3'
      stroke_horizontal_rule
    end

    move_down 20
    txt = "Descripción con las especificaciones técnicas y requisitos de calidad, cantidad y oportunidad del o los bienes, arrendamiento y/o servicios a contratar:"
    text txt,:align=>:justify

    move_down 20
    text "#{justificacion.descripcion}",:align=>:justify

  end

  def fecha(_fecha)
    "#{_fecha.strftime('%d')} de #{get_month_name(_fecha.strftime('%m').to_i)} de #{_fecha.strftime('%Y')}"
  end

  def get_month_name(number)
    months = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"]
    name = months[number - 1]
    return name
  end

end