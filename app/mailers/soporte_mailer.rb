class SoporteMailer < ApplicationMailer
  def soporte_email(soporte, adminusers)
    @soporte = soporte
    emails = adminusers.collect(&:email).join(",")
    mail(to: emails, subject: 'Nuevo Requerimiento')
  end

  def soporte_observacion(soporte, soportesnota)
    @soporte = soporte
    @soportesnota = soportesnota
    mail(to: @soporte.user.email, subject: 'Observación de tu Requerimiento')
  end

  def soporte_observacion_cliente(soporte, soportesnota, adminusers)
    @soporte = soporte
    @soportesnota = soportesnota
    emails = adminusers.collect(&:email).join(",")
    mail(to: emails, subject: 'Observación de Requerimiento')
  end

  def soporte_atendido(soporte)
    @soporte = soporte
    mail(to: @soporte.user.email, subject: '¡Requerimiento atendido!')
  end
end
