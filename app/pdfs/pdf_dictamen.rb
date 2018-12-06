class PdfDictamen < Prawn::Document

  def initialize(justificacion)
    super()

    proveedor_seleccionado = Proveedor.find(justificacion.proveedor_id)
    proveedor_seleccionado.razon_social = proveedor_seleccionado.razon_social.blank? ? '' : proveedor_seleccionado.razon_social
    proveedor_seleccionado.rfc = proveedor_seleccionado.rfc.blank? ? '' : proveedor_seleccionado.rfc
    proveedor_seleccionado.domicilio = proveedor_seleccionado.domicilio.blank? ? '' : proveedor_seleccionado.domicilio
    proveedor_seleccionado.email = proveedor_seleccionado.email.blank? ? '' : proveedor_seleccionado.email
    proveedor_seleccionado.telefono = proveedor_seleccionado.telefono.blank? ? '' : proveedor_seleccionado.telefono

    @justificacion = justificacion

    es_unico = justificacion.proveedores.length == 1

    mas_iva = ""
    if(justificacion.iva > 0.00 ) then
      mas_iva = " más IVA"
    end

    diasCorresponde = 'corresponde a '+justificacion.num_dias_plazo.to_s+' días'
    if justificacion.num_dias_plazo == 1
      diasCorresponde = 'corresponde a un día'
    end

    @map = Hash[
        'plazo_0' => "El plazo en que se requiere el suministro de los #{@justificacion.biensServicios}, corresponde al periodo del "+
        fecha(justificacion.fecha_inicio) + ' y hasta el '+ fecha(justificacion.fecha_termino)+
        ". Las condiciones en las que se entregarán los  #{@justificacion.biensServicios} son las siguientes:\n\n"+ @justificacion.condiciones_pago,

        'plazo_1' => "La fecha en que se requiere el suministro de los  #{@justificacion.biensServicios}, corresponde al día "+
            fecha(justificacion.fecha_termino)+ '. Las condiciones en las que se '+
        "entregarán los  #{@justificacion.biensServicios} son las siguientes:\n\n "+@justificacion.condiciones_pago,

        'plazo_2' => "El plazo en que se requiere el suministro de los  #{@justificacion.biensServicios}, " + diasCorresponde+
        ' después de la elaboración de este documento.'+' Las condiciones en las que se entregarán los '+
        "#{@justificacion.biensServicios} son las siguientes:\n\n " + @justificacion.condiciones_pago
    ]

    font 'Helvetica'
    font_size 11

    move_down 10
    text 'JUSTIFICACIÓN Y DICTAMEN DE USUARIO', style: :bold, align: :center

    move_down 30
    text "C.P. JOSE MARIA ESTRADA GOMEZ \nENCARGADO DEL DESPACHO DEL DEPARTAMENTO DE ADQUISICIONES \nCIMAV, S.C.\n PRESENTE.",
         style: :bold
    move_down 20
    indent(336) do
      txt = "Asunto: Se emite justificación y dictamen.
           Por lo que se acredita y funda la contratación por adjudicación directa que se indica."
      text txt, size: 10
    end

    move_down 20
    txt ="En cumplimiento a lo establecido en el segundo párrafo del artículo 40 de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Publico, así como en el artículo 71 del Reglamento de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Publico, y con el carácter de Titular del Área Requirente,  por este conducto hago constar  el acreditamiento de los criterios, razones, fundamentos y motivos para no llevar a cabo el procedimiento de licitación pública y celebrar la contratación a través del procedimiento de Adjudicación Directa, mediante los procesos de excepción a la licitación pública establecidos en el artículo 41 de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Publico, para lo cual se presenta la siguiente información:"
    text txt, :align=>:justify

    move_down 20
    txt ="I.- DESCRIPCION DE LOS #{@justificacion.biensServicios.upcase}: #{justificacion.partida.texto.upcase}"
    text txt, :align=>:center, style: :bold

    move_down 20
    txt = "El suministro de bienes consumibles que se pretende contratar es el correspondiente a la adquisición de Herramientas \f
Menores para trabajos en  el mantenimiento del equipo y edificio del Centro de Investigación en Materiales Avanzados, \f
S.C. en adelante el <b>CIMAV</b>, conforme a la suficiencia presupuestal autorizada en las partidas \f
número <b>#{justificacion.partida.texto.upcase}</b> del presupuesto anual autorizado al <b>CIMAV</b>  para \f
el ejercicio 2018, el cual forma parte de los bienes que se suministran al personal para el desempeño de sus actividades."
    txt = txt.gsub(/\f\n/, '')
    text txt, :align=>:justify, :inline_format => true

    move_down 10
    text "#{justificacion.descripcion}", :align=>:justify, :inline_format => true

    move_down 20
    txt ="II.- PLAZOS Y CONDICIONES DEL SUMINISTRO DEL SERVICIO"
    text txt, :align=>:center, style: :bold

=begin
    move_down 20
    txt = "El plazo en el que se requiere que se suministren los bienes, corresponde al periodo del \f
<b>#{justificacion.fecha_inicio}</b> al <b>#{justificacion.fecha_termino}</b>.Las condiciones en las que se proporcionaran los \f
bienes son las siguientes:"
    txt = txt.gsub(/\f\n/, '')
    text txt, :align=>:justify, :inline_format => true
=end
    move_down 20
    text "#{@map['plazo_'+@justificacion.plazo.to_s]}",align: :justify

    start_new_page

    move_down 20
    txt ="III.- RESULTADO DE LA INVESTIGACION DE MERCADO"
    text txt, :align=>:center, style: :bold

    move_down 20
    txt = "La investigación de mercado fue realizada en los términos del artículo 26 sexto párrafo de la Ley de Adquisiciones, \f
Arrendamientos y Servicios del Sector Publico, así como en los artículos 28,29 y 30 del Reglamento de la Ley de Adquisiciones, \f
Arrendamientos y Servicios del Sector Publico, en forma conjunta por el Área Requirente y el Área Contratante, en la cual se \f
verificó previo al inicio del procedimiento de contratación, la existencia de oferta, en la cantidad, calidad y oportunidad \f
requeridas; la existencia de proveedores a nivel nacional o internacional con posibilidad de cumplir con las necesidades de la \f
contratación, conocer el precio prevaleciente al momento de llevar a cabo la Investigación de mercado así como en la información \f
disponible en el Sistema informático denominado COMPRANET:"
    txt = txt.gsub(/\f\n/, '')
    text txt, :align=>:justify, :inline_format => true

    if es_unico then
      move_down 20
      celda0 = {:content => '<b>PROVEEDOR</b>',:inline_format => true, size: 10, :borders => [:bottom], :border_color => "b3b3b3"}
      celda1 = {:content => '<b>IMPORTE SIN IVA</b>',:inline_format => true, align: :right, size: 10, :borders => [:bottom], :border_color => "b3b3b3"}
      celda2 = {:content => "<b>#{proveedor_seleccionado.razon_social}</b>", size: 10, :borders => [], :inline_format => true, :padding => 2}
      celda3 = {:content => "<b>#{monto_to_currency(proveedor_seleccionado.monto)}</b>",:inline_format => true, align: :right, size: 10, :borders => [], :padding => 2}

      data = [[celda0, celda1],
              [celda2, celda3]]
      indent(30,30)do
        table(data, :column_widths => [350, 110])
      end
      move_down 20
        text'Concluyendo que en conjunto es la única oferta en cuanto a obtener las mejores condiciones, calidad, '+
                "precio, oportunidad y financiamiento, por ser el único proveedor que proporcione los #{justificacion.biensServicios} que se pretende " +
                "contratar la de <b>#{proveedor_seleccionado.razon_social.upcase}</b>. La referida Investigación de Mercado " +
                "se acompaña a la presente justificación para determinar que el procedimiento de contratación por " +
                "adjudicación directa es el idóneo.",:align=>:justify, :inline_format => true

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

      indent(50,30)do
        table(data, :column_widths => [350, 110])
      end

        move_down 14
        text "Motivo de la selección: #{justificacion.motivo_seleccion}.",align: :justify
        move_down 10
        txt ="Siendo la oferta que en conjunto presenta las mejores condiciones en cuanto a calidad, precio, oportunidad \f
    y financiamiento, la de <b>#{proveedor_seleccionado.razon_social}</b>. La referida Investigación de Mercado se acompaña a \f
    la presente justificación para determinar que el procedimiento de contratación por adjudicación directa es el idóneo."
        txt = txt.gsub(/\f\n/, '')
        text txt, :align => :justify, :inline_format => true
    end

    move_down 20
    text "IV.- PROCEDIMIENTO DE CONTRATACION PROPUESTO", :align=>:center, style: :bold
    move_down 20
    txt ="El procedimiento de contratación propuesto es el de adjudicación directa bajo el supuesto de excepción a la licitación pública \f
establecido en la fracción #{justificacion.tipo.romano} del artículo 41 de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector \f
Publico el cual señala que cuando <b>“Se haya declarado desierta una licitación pública, siempre que se mantengan los requisitos establecidos \f
en la convocatoria a la licitación cuyo incumplimiento haya sido considerado como causa de desechamiento porque afecta directamente la \f
solvencia de las proposiciones“</b>; así como a lo establecido en el artículo 72 fracción #{justificacion.tipo.romano} del Reglamento de la Ley de Adquisiciones, \f
Arrendamientos y Servicios del Sector Publico el cual establece que <b>“El supuesto a que se refiere la fracción #{justificacion.tipo.romano}, \f
sólo resultará procedente cuando se mantengan los mismos requisitos cuyo incumplimiento se consideró como causa de desechamiento en la \f
convocatoria a la licitación pública declarada desierta, incluidas las modificaciones derivadas de las juntas de aclaraciones correspondientes; \f
dentro de dichos requisitos, se considerará la cantidad de bienes o servicios indicada en la convocatoria a la primera licitación pública. \f
Lo anterior será aplicable para el caso de las partidas que se hayan declarado desiertas en una licitación pública“</b>."
    txt = txt.gsub(/\f\n/, '')
    text txt, :align=>:justify, :inline_format => true

    move_down 20
    text "IV.1. MOTIVACION Y FUNDAMENTACION LEGAL:", :align=>:center, style: :bold
    move_down 20
    indent (20) do
      txt ="<b> A. MOTIVOS:</b> La contratación de los #{@justificacion.biensServicios} objeto de la presente justificación es necesaria para satisfacer los requerimientos \f
del proyecto identificado por: #{justificacion.proyecto} #{justificacion.razon_compra}, el cual se requiere para dar cumplimiento a las obligaciones \f
y compromisos establecidos en las disposiciones normativas contraídas por el centro como parte de sus actividades propias.

Por lo anterior, resulta aplicable el supuesto de excepción previsto en la fracción #{justificacion.tipo.romano} del artículo 41 de la Ley de \f
Adquisiciones, Arrendamientos y Servicios del Sector Publico, así como lo dispuesto  en el artículo 72 del Reglamento de la Ley de Adquisiciones, \f
Arrendamientos y Servicios del Sector Publico, tal y como se desprende de la información presentada en este dictamen y  justificación,  por lo que \f
resulta procedente la contratación bajo la modalidad de adjudicación directa prevista en el artículo 26 fracción III de la Ley de Adquisiciones, \f
Arrendamientos y Servicios del Sector Publico.

     <b>B. FUNDAMENTOS:</b> La contratación se encuentra debidamente fundada en el artículo 134 de la Constitución Política de los Estados Unidos \f
Mexicanos, en los artículos 26 fracción III, 40 Y 41 fracción  #{justificacion.tipo.romano} de la Ley de Adquisiciones, Arrendamientos y Servicios \f
del Sector Publico, así como en los artículos 71 #{justificacion.mostrar72} del Reglamento de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Publico."
      txt = txt.gsub(/\f\n/, '')
      text txt, :align=>:justify, :inline_format => true
    end

    move_down 20
    text "V.- MONTO ESTIMADO Y FORMA DE PAGO PROPUESTO", :align=>:center, style: :bold
    move_down 20
    text "V.1.   MONTO ESTIMADO:", style: :bold
    move_down 5
    txt ="El monto estimado de la contratación es la cantidad de #{monto_to_currency(proveedor_seleccionado.monto)}#{mas_iva}, \f
mismo que resultó el más conveniente de acuerdo con la Investigación de Mercado, mediante la cual se verificó previo al inicio del procedimiento de \f
contratación, la existencia de oferta de los #{@justificacion.biensServicios} en la cantidad, calidad y oportunidad requeridos en los términos del artículo 28 del Reglamento \f
de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Público."
    txt = txt.gsub(/\f\n/, '')
    text txt, :align=>:justify, :inline_format => true

    move_down 20
    subTotal = proveedor_seleccionado.monto
    total = justificacion.iva + subTotal

    celda0 = {:content => 'Importe sin IVA: ',:inline_format => true, align: :right, size: 10, :borders => [], :padding=>2}
    celda1 = {:content => 'Iva: ',:inline_format => true, align: :right, size: 10, :borders => [], :padding=>2}
    celda2 = {:content => '<b>Total: </b>', size: 10, align: :right,:borders => [], :inline_format => true, :padding=>2}
    celda3 = {:content => "#{monto_to_currency(proveedor_seleccionado.monto)}",:inline_format => true, align: :right, size: 10, :borders => [], :padding=>2}
    celda4 = {:content => "#{monto_to_currency(justificacion.iva)}",:inline_format => true, align: :right, size: 10, :borders => [], :padding=>2}
    celda5 = {:content => "<b>#{monto_to_currency(total)}</b>",:inline_format => true, align: :right, size: 10, :borders => [], :padding=>2}

    data = [[celda0, celda3],
            [celda1, celda4],
            [celda2, celda5],]
    indent(350) do
      table(data)
    end

    move_down 20
    text "V.2.   FORMA DE PAGO PROPUESTA:", style: :bold
    move_down 5
    parcialidad = justificacion.subtotal / justificacion.num_pagos rescue 0.00
    txt ="El monto total será pagado en #{justificacion.num_pagos} pago/s de #{monto_to_currency(parcialidad)}#{mas_iva}. \f
Los pagos se realizarán previa verificación de la entrega y calidad de los #{@justificacion.biensServicios} así como previo envío en formatos .pdf y .xml del Comprobante \f
Fiscal Digital por Internet (CFDI) correspondiente que reúna los requisitos fiscales respectivos. Los pagos se efectuarán mediante transferencia \f
interbancaria."
    txt = txt.gsub(/\f\n/, '')
    text txt, :align=>:justify, :inline_format => true

    move_down 20
    text "VI.- PERSONA PROPUESTA PARA LA ADJUDICACION DIRECTA", :align=>:center, style: :bold
    move_down 20
    txt ="Por lo anteriormente expuesto y fundado, se propone a #{proveedor_seleccionado.razon_social} con domicilio en #{proveedor_seleccionado.domicilio} \f
, Registro Federal de Contribuyentes <i>#{proveedor_seleccionado.rfc}</i> bajo el Régimen General de Ley Personas Morales."
    txt = txt.gsub(/\f\n/, '')
    text txt, :align=>:justify, :inline_format => true

    move_down 20
    indent 10 do
      text "VII.- ACREDITACION DEL O LOS CRITERIOS EN LOS QUE SE FUNDA Y MOTIVA LA SELECCIÓN DEL PROCEDIMIENTO DE EXCEPCION A LA LICITACION PUBLICA", :align=>:center, style: :bold
    end
    move_down 20
    txt ="El procedimiento de contratación por adjudicación directa es el idóneo, al determinarse el supuesto de excepción al procedimiento de licitación pública previsto en el artículo 41, fracción #{justificacion.tipo.romano} de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Publico, aunado  a que se corroboro la capacidad y experiencia de la persona propuesta, quien presento las mejores condiciones en cuanto a precio, calidad, financiamiento, oportunidad y demás circunstancias pertinentes a efecto de asegurar al Centro de Investigación en Materiales Avanzados, S.C. las mejores condiciones para su contratación.

El acreditamiento del o los criterios en los que se funda y motiva la excepción a la licitación pública, son los siguientes:"
    txt = txt.gsub(/\f\n/, '')
    text txt, :align=>:justify, :inline_format => true

    # start_new_page

    if justificacion.economica
      txt = "
<b>Economía</b>

Con la investigación de mercado se establecieron precios y demás condiciones de calidad, financiamiento y oportunidad respecto de los #{@justificacion.biensServicios} requeridos, con lo cual se asegura cumplir con los principios del artículo 134 de la Constitución Política de los Estados Unidos Mexicanos y de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Publico, en cuanto a precio, calidad, financiamiento, oportunidad y demás circunstancias pertinentes, por lo que el procedimiento de adjudicación directa permite en contraposición al procedimiento de licitación pública obtener con mayor oportunidad los #{@justificacion.biensServicios} requeridos, generando ahorro de recursos por estar proponiendo la adjudicación del proveedor que mostro más solvencia técnica y económica en cuanto al tipo de servicio contratado.

Lo anterior de acuerdo con lo establecido en el numeral 4.2.4 (Adjudicación Directa) y numeral 4.2.4.1.1 del Acuerdo por el que se modifica el Manual Administrativo de Aplicación General en Materia de Adquisiciones, Arrendamientos y Servicios del Sector Publico, publicado en el Diario Oficial de la Federación el día 03 de febrero de 2016.
"
      txt = txt.gsub(/\f\n/, '')
      text txt, :align=>:justify, :inline_format => true
    end
    if justificacion.eficiencia_eficacia == 0
      txt = "
<b>Eficacia</b>

Con el procedimiento de contratación por adjudicación directa, se lograra obtener con oportunidad los #{@justificacion.biensServicios}, atendiendo a las características requeridas en contraposición con el procedimiento de licitación pública, dado que se reducen tiempos y se atiende en el tiempo requerido la eventualidad para la adquisición de los #{@justificacion.biensServicios} a contratar, así como la generación de  economías, aunado a que la persona propuesta cuenta con experiencia y capacidad para satisfacer las necesidades requeridas, además de que se ofreció las mejores condiciones disponibles en cuanto a precio, calidad y oportunidad, con lo que se lograría el cumplimiento de los objetivos y resultados deseados en el tiempo requerido, por otra parte el proveedor propuesto ya ha realizado este tipo de servicios con anterioridad.

Lo anterior de acuerdo con lo establecido en el numeral 4.2.4 (Adjudicación Directa) y numeral 4.2.4.1.1 del Acuerdo por el que se modifica el Manual Administrativo de Aplicación General en Materia de Adquisiciones, Arrendamientos y Servicios del Sector Publico, publicado en el Diario Oficial de la Federación el día 03 de febrero de 2016.
"
      txt = txt.gsub(/\f\n/, '')
      text txt, :align=>:justify, :inline_format => true
    else
      txt = "
<b>Eficiencia</b>

Con el procedimiento d adjudicación directa, a diferencia del procedimiento de licitación pública, se logra el uso racional de recursos con los que cuenta la entidad para realizar la contratación, obteniendo las mejores condiciones de precio, calidad y oportunidad, evitando la pérdida de tiempo  y recursos al Estado, tal y como lo menciona el artículo 41 fracción #{justificacion.tipo.romano}, se puede realizar de manera eficaz la contratación del servicio requerido para cumplir con la eventualidad y que los servicios a contratar no se vean suspendidos.

Lo anterior de acuerdo con lo establecido en el numeral 4.2.4 (Adjudicación Directa) y numeral 4.2.4.1.1 del Acuerdo por el que se modifica el Manual Administrativo de Aplicación General en Materia de Adquisiciones, Arrendamientos y Servicios del Sector Publico, publicado en el Diario Oficial de la Federación el día 03 de febrero de 2016.


<b>Imparcialidad</b>

El tipo de adjudicación que se propone, se llevaría a cabo sin prejuicios ni situaciones que  pudieran afectar la imparcialidad, y sin que medie algún interés personal de los servidores públicos involucrados en la contratación o de cualquier otra índole que pudiera otorgar condiciones ventajosas  a alguna de las personas que presento cotización, en relación con los demás ni limitar la libre participación, ya que todos y cada uno de las personas evaluadas contaron de manera imparcial con toda la información para que quienes estuvieran y quisieran, pudieran participar con sus propuestas de manera imparcial y equitativa sin intervención ya sea a favor o en contra de algunos participantes de ningún servidor público.

Lo anterior de acuerdo con lo establecido en el numeral 4.2.4 (Adjudicación Directa) y numeral 4.2.4.1.1 del Acuerdo por el que se modifica el Manual Administrativo de Aplicación General en Materia de Adquisiciones, Arrendamientos y Servicios del Sector Publico, publicado en el Diario Oficial de la Federación el día 03 de febrero de 2016.


<b>Honradez</b>

La selección del procedimiento de adjudicación directa tiene como único fin contratar bajo las mejores condiciones los #{@justificacion.biensServicios} requeridos, actuando con rectitud, responsabilidad e integridad y con apego estricto al marco jurídico aplicable, evitando así incurrir en actos de corrupción, ya que no se ha favorecido a persona alguna interesada en la contratación y se ha exigido la misma conducta a las personas que presentaron cotización, asimismo, en el proceso de análisis de propuestas, así como para la obtención de las mismas se involucró a diversos servidores públicos de las áreas administrativas que tienen bajo su control esta actividad.

Lo anterior de acuerdo con lo establecido en el numeral 4.2.4 (Adjudicación Directa) y numeral 4.2.4.1.1 del Acuerdo por el que se modifica el Manual Administrativo de Aplicación General en Materia de Adquisiciones, Arrendamientos y Servicios del Sector Publico, publicado en el Diario Oficial de la Federación el día 03 de febrero de 2016.

<b>Transparencia</b>

Todas las personas que han presentado cotización para la integración del procedimiento de contratación  por adjudicación directa, han tenido acceso de manera oportuna, clara y completa de las características requeridas de los #{@justificacion.biensServicios}, en el entendido que para garantizar la transparencia del procedimiento de contratación, la información se solicitó con las mismas bases y características, otorgando la misma oportunidad de presentar las propuestas, cuya contratación respectiva será incorporada al Sistema de Compras Gubernamentales (CompraNet), en los términos de las disposiciones legales aplicables.

Lo anterior de acuerdo con lo establecido en el numeral 4.2.4 (Adjudicación Directa) y numeral 4.2.4.1.1 del Acuerdo por el que se modifica el Manual Administrativo de Aplicación General en Materia de Adquisiciones, Arrendamientos y Servicios del Sector Publico, publicado en el Diario Oficial de la Federación el día 03 de febrero de 2016."
      txt = txt.gsub(/\f\n/, '')
      text txt, :align=>:justify, :inline_format => true
    end

    move_down 20
    text "VIII.- LUGAR Y FECHA DE EMISION", :align=>:center, style: :bold
    move_down 20

    txt ="En la ciudad de Chihuahua, Chihuahua, al <b>#{fecha(justificacion.fecha_elaboracion)}</b>, se emite el  presente dictamen y  justificación para los efectos legales a que haya lugar.

En cumplimiento a lo establecido en el penúltimo párrafo del artículo 71 del Reglamento de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Publico, se acompañara al presente la requisición,  a la cual se le deberá anexar, mediante sello del Departamento de Presupuesto, la constancia con la que se acredita la existencia de recursos para iniciar el procedimiento de contratación."
    txt = txt.gsub(/\f\n/, '')
    text txt, :align=>:justify, :inline_format => true

    move_down 20

    if y < 400 then
      start_new_page
    end

    text "IX.- DICTAMEN", :align=>:center, style: :bold
    move_down 20
    txt ="Con fundamento a lo establecido en los artículos 40 y 41 penúltimo párrafo de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Público y una vez \f
acreditados los criterios, razones, fundamentos y los motivos sobre la procedencia de la excepción a la licitación pública, con el carácter de titular del área requirente, \f
<b>dictamino</b> bajo mi propia responsabilidad, sobre la procedencia de la excepción a la licitación pública y al procedimiento de contratación por adjudicación directa del \f
suministro de los #{@justificacion.biensServicios} consumibles de herramientas menores para el mantenimiento del equipo y edificio del Centro de Investigación en Materiales Avanzados, S.C. (CIMAV) “; \f
cuya partida presupuestal según el clasificador por objeto del gasto es  la numero” <b>“#{justificacion.partida.texto}”</b> por encontrarse el caso antes mencionado en el \f
supuesto de excepción, en la fracción #{justificacion.tipo.romano} del   artículo 41 de la Ley de Adquisiciones, Arrendamientos y Servicios del Sector Publico, el cual \f
señala que  cuando <b>“Se haya declarado desierta una licitación pública, siempre que se mantengan los requisitos establecidos en la convocatoria a la licitación cuyo \f
incumplimiento haya sido considerado como causa de desechamiento porque afecta directamente la solvencia de las proposiciones”</b>."
    txt = txt.gsub(/\f\n/, '')
    text txt, :align=>:justify, :inline_format => true

    move_down 70
    text "ATENTAMENTE",style: :bold, align: :center, size: 12, character_spacing: 0.30
    move_down 50
    text "#{justificacion.autorizo.nombre}\n#{justificacion.autoriza_cargo.upcase}", style: :bold, align: :center, size: 12, character_spacing: 0.30

    number_pages"<page> / <total>", :at => [bounds.right - 165, -15],
                :width => 150,
                :align => :right,
                :size => 10,
                :start_count_at => 1


    #stroke_axis
  end

  def fecha(_fecha)
    "#{_fecha.strftime('%d')} de #{get_month_name(_fecha.strftime('%m').to_i)} de #{_fecha.strftime('%Y')}"
  end

  def monto_to_currency(monto)
    ActionController::Base.helpers.number_to_currency(monto, :unit => @justificacion.moneda.simbolo) + " " +  @justificacion.moneda.code
  end

  def get_month_name(number)
    months = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"]
    name = months[number - 1]
    return name
  end

end