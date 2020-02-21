class ProveedorMailer < ApplicationMailer

  def send_focon04(proveedor, justificacion)

    @proveedor = proveedor
    @justificacion = justificacion

    reply_to = proveedor.reply_to.blank? ? "#{justificacion.elaboro.nombre} <#{justificacion.elaboro.cuenta_cimav}@cimav.edu.mx>" : proveedor.reply_to

    filename = "Cotizacion_#{@justificacion.requisicion}.pdf"
    pdf = PdfCotizacion.new(@justificacion, proveedor.id)
    attachments[filename] = Tempfile.create do |f|
      pdf.render_file f
      f.flush
      File.read(f)
    end

    mail(:to => proveedor.email,
         :from => 'Adquisiciones Cimav <servicio.cliente@cimav.edu.mx>',
         :subject=>"CIMAV - Solicitud de cotización ##{@justificacion.requisicion}",
         :reply_to => reply_to)

  end

end