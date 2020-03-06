class ProveedorMailer < ApplicationMailer

  def send_focon04(proveedor, justificacion)

    @proveedor = proveedor
    @justificacion = justificacion

    reply_to = proveedor.reply_to.blank? ? "#{justificacion.elaboro.nombre} <#{justificacion.elaboro.cuenta_cimav}@cimav.edu.mx>" : proveedor.reply_to

    # Focon04
    filename = "Cotizacion_#{@justificacion.requisicion}.pdf"
    pdf = PdfCotizacion.new(@justificacion, proveedor.id)
    attachments[filename] = Tempfile.create do |f|
      pdf.render_file f
      f.flush
      File.read(f)
    end
    # anexos
    @justificacion.anexos.each do |anexo|
      file_path = File.join(Rails.root.to_s, 'public', anexo.url)
      attachments[anexo.file.filename] =  File.read(file_path)
    end

    mail(:to => proveedor.email,
         :from => 'Adquisiciones Cimav <servicio.adquisiciones@cimav.edu.mx>',
         :subject=>"CIMAV - Solicitud de cotización ##{@justificacion.requisicion}",
         :reply_to => reply_to)

  end

end