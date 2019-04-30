#!/bin/env ruby
# encoding: utf-8

class PdfJustificacion < Prawn::Document

  def initialize(justificacion)
    super()

      # @moneda = Justificacion.select(justificacion.id_moneda).joins(:monedas)
    @justificacion =  justificacion
    @plazo = 0
    #@id_tipo = 2
    @mas_iva = ""
    @code = "MXN"
    @simbolo = "$"

    proveedor_seleccionado = Proveedor.find(justificacion.proveedor_id)
    proveedor_seleccionado.razon_social = proveedor_seleccionado.razon_social.blank? ? '' : proveedor_seleccionado.razon_social
    proveedor_seleccionado.rfc = proveedor_seleccionado.rfc.blank? ? '' : proveedor_seleccionado.rfc
    proveedor_seleccionado.domicilio = proveedor_seleccionado.domicilio.blank? ? '' : proveedor_seleccionado.domicilio
    proveedor_seleccionado.email = proveedor_seleccionado.email.blank? ? '' : proveedor_seleccionado.email
    proveedor_seleccionado.telefono = proveedor_seleccionado.telefono.blank? ? '' : proveedor_seleccionado.telefono

    # si es Unico, la fraccion sera 1 siempre
    # es_unico = justificacion.proveedores.length == 1
    es_unico = justificacion.tipo.fraccion == 1
    romano = es_unico ? 'I' : justificacion.tipo.romano

    # Operaciones Internas para el manejo de variables

    @diasCorresponde = "corresponde a <b>#{@justificacion.num_dias_plazo} días</b>"
    if @justificacion.num_dias_plazo == 1 then
      @diasCorresponde = "corresponde a <b>un día</b>"
    end

    if(@justificacion.iva > 0.00 ) then
      @mas_iva = " más IVA y retenciones a las que haya lugar"
    end

    #entrega = table([ ["•","#{@justificacion.terminos_entrega}"],
    #                  ["•", " #{@justificacion.lugar_entrega}"]])
    #

    entrega = "#{@justificacion.terminos_entrega} \n\n #{@justificacion.lugar_entrega}"

    @map = Hash['texto1_I' => "No existan bienes o servicios alternativos o sustitutos técnicamente razonables, o bien, que en el \f
mercado sólo existe un posible oferente, o se trate de una persona que posee la titularidad o el licenciamiento exclusivo de patentes, \f
derechos de autor, u otros derechos exclusivos, o por tratarse de obras de arte.",

                'texto1_III' => "Existan circunstancias que puedan provocar pérdidas o costos adicionales importantes, cuantificados y justificados.",

                'texto1_XIV' => "Se trate de los servicios prestados por una persona física a que se refiere la fracción VII del artículo 3 de esta Ley, \f
siempre que éstos sean realizados por ella misma sin requerir de la utilización de más de un especialista o técnico",

                'texto1_XV' => "Se trate de servicios de mantenimiento de #{@justificacion.biensServicios} en los que no sea posible precisar su alcance, establecer las \f
cantidades de trabajo o determinar las especificaciones correspondientes.",

                'texto1_XVII' => "Se trate de equipos especializados, sustancias, y materiales de origen químico, físico químico o bioquímico para ser \f
utilizadas en actividades experimentales requeridas en proyectos de investigación científica y desarrollo tecnológico, siempre que dichos proyectos se \f
encuentren autorizados por quien determine el titular de la dependencia o el órgano de gobierno de la entidad.",

                'plazo_0' => "El plazo en que se requiere el suministro de los #{@justificacion.biensServicios}, corresponde al periodo del \f
<b>#{fecha(justificacion.fecha_inicio)}</b> y hasta el <b>#{fecha(justificacion.fecha_termino)}</b>. Las condiciones en las que se entregarán los #{@justificacion.biensServicios} son las siguientes:\n\n #{entrega}",

                'plazo_1' => "La fecha en que se requiere el suministro de los #{@justificacion.biensServicios}, corresponde al día \f
<b>#{fecha(justificacion.fecha_termino)}</b>. Las condiciones en las que se entregarán los #{@justificacion.biensServicios} son las siguientes:\n\n #{entrega}",

                'plazo_2' => "El plazo en que se requiere el suministro de los #{@justificacion.biensServicios}, #{@diasCorresponde} según la cotización del proveedor elegido. \f
Las condiciones en las que se entregarán los #{@justificacion.biensServicios} son las siguientes:\n\n #{entrega}",

                'nota_1' => "Asimismo se hace constar mediante el sello y firma del responsable del área de Almacén, la No Existencia de Bienes o Nivel de Inventario \f
que demuestra que se cumplió con lo establecido en el artículo 27 del RLAASP.",

                'transparecia_unico' =>"Para la integración del procedimiento de contratación por adjudicación directa, los servidores públicos de las áreas requirentes han tenido acceso \f
de manera oportuna, clara y completa de las características requeridas de los  #{@justificacion.biensServicios} con el fin de demostrar que es el único proveedor que proporciona \f
los #{@justificacion.biensServicios} que se pretenden contratar, en el entendido que para garantizar la transparencia del procedimiento de contratación, la información respectiva \f
será incorporada al Sistema de Compras Gubernamentales (CompraNet), en los términos de las disposiciones legales aplicables, Lo anterior de acuerdo con lo establecido en el \f
numeral 4.2.4 (ADJUDICACIÓN DIRECTA) y numeral 4.2.4.1.1 (Verificar Acreditamiento de Excepción) del Acuerdo por el que se modifica el Manual Administrativo de Aplicación General en Materia \f
de Adquisiciones, Arrendamientos y Servicios del Sector Público, publicado en el Diario Oficial de la Federación el 21 de noviembre de 2012.",

                'transparencia_no_unico' =>'Todas las personas que han presentado cotización para la integración del '+
                    'procedimiento de contratación por adjudicación directa, han tenido acceso de manera oportuna, clara y '+
                    "completa de las características requeridas de los  #{@justificacion.biensServicios}, en el entendido que para garantizar "+
                    'la transparencia del procedimiento de contratación, la información respectiva será incorporada al '+
                    'Sistema de Compras Gubernamentales (CompraNet), en los términos de las disposiciones legales aplicables. '+
                    'Lo anterior de acuerdo con lo establecido en el numeral 4.2.4 (ADJUDICACIÓN DIRECTA) y numeral 4.2.4.1.1 '+
                    '(Verificar Acreditamiento de Excepción) del Acuerdo por el que se modifica el Manual Administrativo de '+
                    'Aplicación General en Materia de Adquisiciones, Arrendamientos y Servicios del Sector Público, '+
                    'publicado en el Diario Oficial de la Federación el 21 de noviembre de 2012.']

    font_families.update("Arial" => {
        :normal => "public/assets/fonts/Arial.ttf",
        :italic => "public/assets/fonts/Arial Italic.ttf",
        :bold => "public/assets/fonts/Arial Bold.ttf",
        :bold_italic => "public/assets/fonts/Arial Bold Italic.ttf"
    })
    font "Arial"

    #font "/Library/Fonts/Verdana.ttf" #Arial Unicode
    # font "/Library/Fonts/Arial"
    # font 'Times-Italic'
    #titulo del documento
    move_down 10
    text "Centro de Investigación en Materiales Avanzados S. C.", size: 17, style: :normal, align: :center

    #Parrafo consiguiente al titulo
    move_down 20
    indent(30) do
      text 'JUSTIFICACIÓN PARA ACREDITAR Y FUNDAR PROCEDIMIENTOS DE '+
               'CONTRATACION POR ADJUDICACION DIRECTA, COMO EXCEPCION AL DE '+
               "LICITACION PUBLICA EN EL SUPUESTO DEL ARTICULO 41 FRACCION  #{romano} DE LA "+
               'LEY DE ADQUISICIONES, ARRENDAMIENTOS Y SERVICIO EN EL SECTOR PUBLICO.',
           style: :bold,align: :justify, character_spacing: 0.25, size: 12
    end

    move_down 50
    indent(100,100) do
      text 'COMITÉ DE ADQUISICIONES, ARRENDAMIENTOS Y SERVICIOS', align: :center, size: 13, leading: 3
    end

    move_down 30
    text 'P R E S E N T E:', style: :bold, indent_paragraphs: 30

    move_down 20
    req = @justificacion.requisicion

    indent(310)do
      text 'Oficio número: '+"<b>#{req}</b>", character_spacing: 5.5, align: :right, inline_format: true

      text 'Asunto: Se emite la justificación por la que se '+
               'acredita y funda la contratación por adjudicacion directa que se indica.',
           align: :justify, character_spacing: 1, size: 12, leading: 1.5
    end

    move_down 30
    indent(30) do
      text 'En cumplimiento a lo establecido en el segundo párrafo del artículo 40 de la Ley de Adquisiciones, '+
               'Arrendamientos y Servicios del Sector Público, así como en el artículo 71 del '+
               'Reglamento de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Público, y con el '+
               'carácter de Titular del Área Requirente, por este conducto hago constar el acreditamiento del o '+
               'de los criterios, razones, fundamentos y motivos para no llevar a cabo el procedimiento de '+
               'licitación pública y celebrar la contratación a través del procedimiento de adjudicación directa en '+
               "los términos establecidos en el artículo 41 Fracción #{romano} de la Ley de Adquisiciones, "+
               'Arrendamientos y Servicios del Sector Público', :align => :justify, character_spacing: 0.20, size:12, leading: 1
    end

    move_down 30
    text 'Para tal efecto presento la siguiente información:',size: 12, align: :justify, indent_paragraphs: 60

    move_down 30
    text "I.- DESCRIPCIÓN DE LOS  #{@justificacion.biensServicios.upcase}", style: :bold, align: :center, size: 12
    move_down 10
    text "El/Los  #{@justificacion.biensServicios} que se pretende contratar, son los siguientes: ", size: 12, align: :justify, indent_paragraphs: 30
    move_down 20

    descService = @justificacion.descripcion #.force_encoding("Windows-1252")
    indent(30)do
      text descService, size: 12, align: :justify, leading: 2
    end

    move_down 30
    text "II.- PLAZOS Y CONDICIONES DEL SUMINISTRO DE LOS  #{@justificacion.biensServicios.upcase}", style: :bold, align: :center, size: 12
    move_down 10
    indent(30) do
      text "#{@map['plazo_'+@justificacion.plazo.to_s]}".gsub(/\f\n/, ''),size: 12, align: :justify, leading: 1, character_spacing: 0.5, inline_format: :true
    end

    move_down 30
    text 'III.- RESULTADO DE LA INVESTIGACIÓN DE MERCADO  ', style: :bold, align: :center, size: 12
    move_down 10
    indent(30) do
      text 'La Investigación de Mercado fue realizada en los términos de los artículos 28, 29 y 30 del '+
               'Reglamento de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Público, en '+
               'forma conjunta por el Área Requirente y el Área Contratante, en la cual se verificó previo al'+
               'inicio del procedimiento de contratación, la existencia de oferta, en la cantidad, calidad y '+
               'oportunidad requeridas; la existencia de proveedores a nivel nacional o internacional con '+
               'posibilidad de cumplir con las necesidades de la contratación, conocer el precio prevaleciente al '+
               'momento de llevar a cabo la Investigación de mercado así como en la información disponible '+
               'en el Sistema informático denominado COMPRANET:',
           size: 12, align: :justify, leading: 1.5, character_spacing: 0.18
    end

    if es_unico then
      move_down 20
      celda0 = {:content => '<b>PROVEEDOR</b>',:inline_format => true, size: 10, :borders => [:bottom], :border_color => "b3b3b3"}
      celda1 = {:content => '<b>IMPORTE SIN IVA</b>',:inline_format => true, align: :right, size: 10, :borders => [:bottom], :border_color => "b3b3b3"}
      celda2 = {:content => "<b>#{proveedor_seleccionado.razon_social}</b>", size: 10, :borders => [], :inline_format => true, :padding => 2}
      celda3 = {:content => "<b>#{monto_to_currency(proveedor_seleccionado.monto)}</b>",:inline_format => true, align: :right, size: 10, :borders => [], :padding => 2}

      data = [[celda0, celda1],
              [celda2, celda3]]

      indent(50,30)do
        table(data, :column_widths => [350, 110])
      end
      move_down 20
      indent(30) do
        text'Concluyendo que en conjunto es la única oferta en cuanto a obtener las mejores condiciones, calidad, '+
                "precio, oportunidad y financiamiento, por ser el único proveedor que proporcione los #{@justificacion.biensServicios} que se pretende " +
                "contratar la de <b>#{proveedor_seleccionado.razon_social.upcase}</b>. La referida Investigación de Mercado " +
                "se acompaña a la presente justificación para determinar que el procedimiento de contratación por " +
                "adjudicación directa es el idóneo.",:align=>:justify, :inline_format => true
      end

      move_down 10
    else
      move_down 20
      celda0 = {:content => '<b>PROVEEDOR</b>',:inline_format => true, size: 10, :borders => [:bottom], :border_color => "b3b3b3"}
      celda1 = {:content => '<b>IMPORTE SIN IVA</b>',:inline_format => true, align: :right, size: 10, :borders => [:bottom], :border_color => "b3b3b3"}

      data = [[celda0, celda1]]

      justificacion.proveedores.map do |prov|
        celda0 = {:content => "#{prov.razon_social}", size: 10, :borders => [], :inline_format => true, :padding => 2}
        celda1 = {:content => "#{monto_to_currency(prov.monto)}",:inline_format => true, align: :right, size: 10, :borders => [], :padding => 2}
        data.push([celda0, celda1])
      end
=begin
      celda2 = {:content => "#{proveedor_seleccionado.razon_social}", size: 10, :borders => [], :inline_format => true, :padding => 2}
      celda3 = {:content => "#{monto_to_currency(proveedor_seleccionado.monto)}",:inline_format => true, align: :right, size: 10, :borders => [], :padding => 2}
      celda4 = {:content => @justificacion.prov2_razon_social, size: 10, :borders => [], :padding => 2}
      celda5 = {:content => "#{monto_to_currency(@justificacion.prov2_monto)}", align: :right, size: 10, :borders => [], :padding => 2}
      celda6 = {:content => @justificacion.prov3_razon_social, size: 10, :borders => [], :padding => 2}
      celda7 = {:content => "#{monto_to_currency(@justificacion.prov3_monto)}", align: :right, size: 10, :borders => [], :padding => 2}
      data = [[celda0, celda1],
              [celda2, celda3],
              [celda4, celda5],
              [celda6, celda7]]
=end

      indent(50,30)do
        table(data, :column_widths => [350, 110])
      end
      move_down 14

      indent(30) do
        text 'Motivo de la selección: ' + @justificacion.motivo_seleccion,size: 12, align: :justify
        move_down 20
        text"Siendo la oferta que en conjunto presenta las mejores condiciones en cuanto a calidad, precio, oportunidad \f
y financiamiento, la de <b>#{proveedor_seleccionado.razon_social.upcase}</b>. La referida Investigación de Mercado se acompaña a la presente justificación para determinar \f
que el procedimiento de contratación por adjudicación directa es el idóneo.".gsub(/\f\n/, ''),size: 12, leading: 2, align: :justify, character_spacing:0.5, :inline_format=>true
      end

    end

    move_down 20
    indent(30) do
      text 'IV.- PROCEDIMIENTO DE CONTRATACIÓN PROPUESTO', style: :bold, align: :center, size: 12
      move_down 20
      text 'El procedimiento de contratación propuesto es el de adjudicación directa, en virtud de que en el '+
               "presente caso la adjudicación se llevaría a cabo conforme la fracción #{romano} del artículo 41 el cual "+
               'menciona que este tipo de adjudicación se puede llevar a cabo siempre y cuando:',
           align: :justify, leading: 2, size: 12, character_spacing: 0.25

      tmp = '' + "texto1_#{romano}" + ''
      text "<b>#{@map[tmp]}</b>".gsub(/\f\n/, '')+ ' ' +
               'Actualizándose el supuesto de excepción a la licitación pública '+
               "establecido en la fracción #{romano} del artículo 41 de la Ley de Adquisiciones, Arrendamientos y "+
               'Servicios del Sector Público, en relación con lo establecido en el artículo 72 de su Reglamento.',
           align: :justify, size: 12, leading: 2, character_spacing: 0.25, :inline_format => true

    end

    move_down 30
    indent(30) do
      text 'IV.1. MOTIVACIÓN Y FUNDAMENTACIÓN LEGAL:', style: :bold
    end
    move_down 20
    proyect = @justificacion.proyecto.to_s
    indent(50) do
      text "<b>A) MOTIVOS:</b> La contratación de los  #{@justificacion.biensServicios} objeto de la presente justificación es necesaria "+
               "para satisfacer los siguientes requerimientos del proyecto número <b>#{proyect}</b>: #{@justificacion.razon_compra}.\n"+
               "\nPor lo anterior, la contratación propuesta se adecúa al supuesto de excepción "+
               'establecido en la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Público en su '+
               "artículo 41, fracción #{romano}; además de que se reúnen los requisitos previstos en el artículo 72 del "+
               'Reglamento de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Público, tal y '+
               'como se desprende de la información presentada en esta justificación, así como de la Investigación '+
               'de Mercado; por lo que resulta procedente la contratación bajo el procedimiento de adjudicación '+
               'directa previsto en el artículo 26, fracción III de la Ley antes mencionada.',
           :align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
      move_down 20
      text "<b>B) FUNDAMENTOS:</b> La contratación se encuentra debidamente fundada en el artículo "+
               '134 de la Constitución Política de los Estados Unidos Mexicanos; en los artículos 26 '+
               "fracción III, 40 y 41 fracción #{romano} de la Ley de Adquisiciones, Arrendamientos y "+
               "Servicios del Sector Público; así como en los artículos 71 #{justificacion.mostrar72} del Reglamento de la "+
               'Ley de Adquisiciones, Arrendamientos y Servicios del Sector Público.',
           :align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
    end

    move_down 30
    text 'IV.-MONTO ESTIMADO Y FORMA DE PAGO PROPUESTO ', style: :bold, align: :center, size: 12
    move_down 20
    indent(30) do
      text 'V.1. MONTO ESTIMADO:', style: :bold
      move_down 20
      text "El monto estimado de la contratación es la cantidad de <b>#{monto_to_currency(proveedor_seleccionado.monto)}</b>#{@mas_iva}, "+
               "mismo resultó el más conveniente de acuerdo con la Investigación de Mercado, "+
               "mediante la cual se verificó previo al inicio del procedimiento "+
               "de contratación, la existencia de oferta de los #{@justificacion.biensServicios} en la cantidad, "+
               "calidad y oportunidad requeridos en los términos del artículo 28 del Reglamento de la Ley de "+
               "Adquisiciones, Arrendamientos y Servicios del Sector Público.",
           :align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
      move_down 20
    end
    subTotal = proveedor_seleccionado.monto
    total = @justificacion.iva + subTotal

    celda0 = {:content => 'SubTotal: ',:inline_format => true, align: :right, size: 10, :borders => [], :padding=>2}
    celda1 = {:content => 'Iva: ',:inline_format => true, align: :right, size: 10, :borders => [], :padding=>2}
    celda2 = {:content => '<b>Total: </b>', size: 10, align: :right,:borders => [], :inline_format => true, :padding=>2}
    celda3 = {:content => "#{monto_to_currency(proveedor_seleccionado.monto)}",:inline_format => true, align: :right, size: 10, :borders => [], :padding=>2}
    celda4 = {:content => "#{monto_to_currency(@justificacion.iva)}",:inline_format => true, align: :right, size: 10, :borders => [], :padding=>2}
    celda5 = {:content => "<b>#{monto_to_currency(total)}</b>",:inline_format => true, align: :right, size: 10, :borders => [], :padding=>2}

    data = [[celda0, celda3],
            [celda1, celda4],
            [celda2, celda5],]
    indent(350) do
      table(data)
    end
    move_down 20
    #sub_total = subTotal.to_s
    indent(30) do
      text 'V.2. FORMA DE PAGO PROPUESTA:', style: :bold
      move_down 20
      parcialidad = (subTotal / justificacion.num_pagos) rescue 0.00


      text "El monto total será pagado en <b>#{justificacion.num_pagos} pago/s de #{monto_to_currency(parcialidad)}</b>#{@mas_iva}. Los pagos se realizarán previa \f
verificación de la entrega y calidad de los #{@justificacion.biensServicios} así como previo envío en formatos .pdf y .xml del Comprobante Fiscal Digital por Internet (CFDI) correspondiente que \f
reúna los requisitos fiscales respectivos. Los pagos se efectuarán mediante TRANSFERENCIA y bajo las siguientes condiciones: \n\n #{justificacion.condiciones_pago}".gsub(/\f\n/, ''),:align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
    end
    move_down 20
    text 'IV.-PROVEEDOR PROPUESTO PARA LA ADJUDICACIÓN DIRECTA: ', style: :bold, align: :center, size: 12
    move_down 20
    indent(30) do
      text 'Por lo anteriormente expuesto y fundado, se propone a ' + proveedor_seleccionado.razon_social.upcase+ ', con domicilio '+
               'ubicado en '+proveedor_seleccionado.domicilio+', Registro Federal de Contribuyentes: '+proveedor_seleccionado.rfc+', correo electrónico: '+proveedor_seleccionado.email+' '+
               'y número telefónico '+proveedor_seleccionado.telefono,
           :align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
    end

    move_down 30
    indent(30)do
      text 'VII.- ACREDITAMIENTO DEL O LOS CRITERIOS EN LOS QUE SE FUNDA Y MOTIVA LA SELECCIÓN DEL PROCEDIMIENTO'+
               ' DE EXCEPCIÓN A LA LICITACIÓN PÚBLICA:', style: :bold, align: :center, size: 12, character_spacing: 0.30
      move_down 10
      text 'El procedimiento de contratación por adjudicación directa es el idóneo, al actualizarse el '+
               "supuesto de excepción al procedimiento de licitación pública previsto en el artículo 41, fracción #{romano} de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Público, aunado a que se "+
               'corroboró la capacidad y experiencia de la persona propuesta, quien '+
               'presentó las mejores condiciones en cuanto a precio, calidad, financiamiento, oportunidad y '+
               'demás circunstancias pertinentes a efecto de asegurar a esta Entidad las mejores condiciones'+
               'para su contratación, tal y como se acredita con la información presentada en esta justificación, '+
               "así como con la Investigación de Mercado.\n\n El acreditamiento del o los criterios en los que se"+
               ' funda la excepción de licitación pública, es el o los siguientes:',
           :align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
      if justificacion.economica
        move_down 20
        text ' - Economía', style: :bold , size:12
        text 'Con la Investigación de Mercado se establecieron precios y demás condiciones de calidad, '+
                 "financiamiento y oportunidad, respecto de los  #{@justificacion.biensServicios} requeridos, con lo cual "+
                 'se asegura cumplir con los principios del artículo 134 de la Constitución Política de los Estados '+
                 'Unidos Mexicanos y de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Público, '+
                 'en cuanto a precio, calidad, financiamiento, oportunidad y demás circunstancias pertinentes, por '+
                 'lo que el procedimiento de adjudicación directa permite en contraposición al procedimiento de '+
                 "licitación pública, obtener con mayor oportunidad los  #{@justificacion.biensServicios} requeridos al "+
                 'menor costo económico para el CIMAV, S.C. según lo detallado en la investigación de mercado '+
                 'que se realizó, generando ahorro de recursos por estar proponiendo la adjudicación al '+
                 'proveedor único cuya propuesta se considera aceptable en cuanto a su solvencia. '+
                 'Lo anterior de acuerdo con lo establecido en el numeral 4.2.4 (ADJUDICACIÓN DIRECTA) y '+
                 'numeral 4.2.4.1.1 (Verificar Acreditamiento de Excepción) del Acuerdo por el que se modifica el '+
                 'Manual Administrativo de Aplicación General en Materia de Adquisiciones, Arrendamientos y '+
                 'Servicios del Sector Público, publicado en el Diario Oficial de la Federación el 21 de noviembre '+
                 'de 2012.',:align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
      end
      if justificacion.eficiencia_eficacia == 1
        move_down 20
        text ' - Eficacia', style: :bold , size:12
        text 'Con el procedimiento de contratación por adjudicación directa, se logrará obtener con '+
                 "oportunidad los  #{@justificacion.biensServicios} atendiendo a las características requeridas en "+
                 'contraposición con el procedimiento de licitación pública, dado que se reducen tiempos y se '+
                 'generan economías; aunado a que la persona propuesta cuenta con experiencia y capacidad '+
                 'para satisfacer las necesidades requeridas, además de que es el único que ofrece las mejores '+
                 'condiciones disponibles en cuanto a precio, calidad y oportunidad, con lo que se lograría el '+
                 'cumplimiento de los objetivos y resultados deseados en el tiempo requerido, situación que se '+
                 'puede demostrar en base a la investigación de mercado. Lo anterior de acuerdo con lo establecido '+
                 'en el numeral 4.2.4 (ADJUDICACIÓN DIRECTA) y numeral 4.2.4.1.1 (Verificar Acreditamiento de '+
                 'Excepción) del Acuerdo por el que se modifica el Manual Administrativo de Aplicación General '+
                 'en Materia de Adquisiciones, Arrendamientos y Servicios del Sector Público, publicado en el '+
                 'Diario Oficial de la Federación el 21 de noviembre de 2012.',
             :align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
      else
        move_down 20
        text ' - Eficiencia', style: :bold , size:12
        text 'Con el procedimiento de adjudicación directa, a diferencia del procedimiento de licitación '+
                 'pública, se logra el uso racional de recursos con los que cuenta la Entidad para realizar la '+
                 'contratación, obteniendo las mejores condiciones de precio, calidad y oportunidad, evitando la '+
                 'pérdida de tiempo y recursos al Estado, lo cual se demuestra con la investigación de mercado que'+
                 'se realizó, quedando evidencia de su resultado ya que los recursos disponibles con los que cuenta '+
                 'el CIMAV se aplican conforme a los lineamientos de racionalidad y austeridad presupuestaria. Lo '+
                 'anterior de acuerdo con lo establecido en el numeral 4.2.4 (ADJUDICACIÓN DIRECTA) y numeral '+
                 '4.2.4.1.1 (Verificar Acreditamiento de Excepción) del Acuerdo por el que se modifica el Manual '+
                 ' Administrativo de Aplicación General en Materia de Adquisiciones, Arrendamientos y Servicios del '+
                 ' Sector Público, publicado en el Diario Oficial de la Federación el 21 de noviembre de 2012.',
             :align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
      end
      move_down 20
      text ' - Imparcialidad', style: :bold , size:12
      text'El tipo de adjudicación que se propone, se llevó a cabo sin prejuicios ni situaciones que pudieran '+
              'afectar la imparcialidad, y sin que medie algún interés personal de los servidores públicos '+
              'involucrados en la contratación o de cualquier otra índole que pudiera otorgar condiciones '+
              'ventajosas a alguna persona, en relación con los demás ni limitar la libre participación, esto '+
              'debido a que es proveedor único, dicha situación queda demostrada conforme al resultado que se da '+
              ' con base a la investigación de mercado. Lo anterior de acuerdo con lo establecido en el numeral '+
              '4.2.4 (ADJUDICACIÓN DIRECTA) y numeral 4.2.4.1.1 (Verificar Acreditamiento de Excepción) del '+
              'Acuerdo por el que se modifica el Administrativo de Aplicación General en Materia de Adquisiciones, '+
              'Arrendamientos Servicios del Sector Público, publicado en el Diario Oficial de la Federación el '+
              '21 de noviembre de 2012.', :align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
      move_down 20
      text '- Honradez', style: :bold , size:12
      text'La selección del procedimiento de adjudicación directa tiene como único fin contratar bajo las '+
              " mejores condiciones los  #{@justificacion.biensServicios} requeridos, actuando con rectitud responsabilidad e integridad y "+
              ' con apego estricto al marco jurídico aplicable, evitando así incurrirbien_servicio en actos de corrupción y '+
              'conflictos de interés, ya que por parte de los servidores públicos que intervinieron en este '+
              'procedimiento quedo evidenciado que no se ha favorecido persona alguna interesada en la '+
              'contratación ya que en base a la investigación de mercado queda demostrado que es proveedor '+
              "único.\n\n Lo anterior de acuerdo con lo establecido en el numeral 4.2.4 (ADJUDICACIÓN DIRECTA) y "+
              'numeral 4.2.4.1.1 (Verificar Acreditamiento de Excepción) del Acuerdo por el que se modifica el '+
              'Manual Administrativo de Aplicación General en Materia de Adquisiciones, Arrendamientos y Servicios '+
              'del Sector Público, publicado en el Diario Oficial de la Federación el 21 de noviembre de 2012.',
          :align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
      move_down 20
    end

    if es_unico
      indent(30) do
        text '- Transparencia', style: :bold , size:12
        text @map['transparecia_unico'].gsub(/\f\n/, ''),
             :align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
      end
    else
      indent(30)do
        text '- Transparencia', style: :bold , size:12
        text @map['transparencia_no_unico'].gsub(/\f\n/, ''),
             :align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
      end
    end

    move_down 40

    if y < 400 then
      start_new_page
    end

    indent(30)do
      text 'VIII.- LUGAR Y FECHA DE EMISIÓN:', style: :bold, align: :center, size: 12, character_spacing: 0.30
      move_down 20
      text "En la Ciudad de Chihuahua, Chihuahua al <b>#{fecha(justificacion.fecha_elaboracion)}</b>, se emite la presente justificación para los efectos legales a que haya lugar.",
           :align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30

      move_down 10
      text 'En cumplimiento a lo establecido en el penúltimo párrafo del artículo 71 del Reglamento de la Ley de '+
               'Adquisiciones, Arrendamientos y Servicios del Sector Público, se acompaña a la presente como '+
               '“ANEXO DOS”, la Requisición o Solicitud de Contratación (Requisición) A la cual se deberá anexar, '+
               'mediante sello del departamento de Presupuesto, la Constancia con la que se acredita la existencia '+
               'de recursos para iniciar el procedimiento de contratación.',
           :align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
    end

    if es_unico
      indent(30)do
        move_down 10
        text @map['nota_1'].gsub(/\f\n/, ''),
             :align => :justify, :inline_format => true, :size => 12, :leading => 2, :character_spacing => 0.30
      end
    end

    move_down 70
    text 'ATENTAMENTE',style: :bold, align: :center, size: 12, character_spacing: 0.30
    move_down 50
    text @justificacion.autorizo.nombre+"\n"+@justificacion.autoriza_cargo.upcase, style: :bold, align: :center, size: 12, character_spacing: 0.30

    number_pages"<page> / <total>", :at => [bounds.right - 165, -15],
                :width => 150,
                :align => :right,
                :size => 10,
                :start_count_at => 1

  end

  def fecha(_fecha)
    "#{_fecha.strftime('%d')} de #{get_month_name(_fecha.strftime('%m').to_i)} de #{_fecha.strftime('%Y')}"
  end

  def get_month_name(number)
    months = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"]
    name = months[number - 1]
    return name
  end

  def monto_to_currency(monto)
    ActionController::Base.helpers.number_to_currency(monto, :unit => @justificacion.moneda.simbolo) + " " +  @justificacion.moneda.code
  end

end