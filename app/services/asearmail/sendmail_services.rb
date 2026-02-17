class Asearmail::SendmailServices

  require 'sendgrid-ruby'
  include SendGrid

  # Descripcion: Metodo generico de envio
  # Fecha: 16-02-2023
  # Autor: AFP
  # Datos de Acceso SendGrid:
  #   Username:notifier.asear@gmail.com
  #   Password: EmpresaAsear2023*
  # Datos de Acceso Correo
  #   Username:notifier.asear@gmail.com
  #   Password: Asear2023*

  # Codigos de Sengrid Api KEY
  # ****************************************
  # ****************************************


  def general(receiver, subject, template, fpath, fname, *args)
    mail = SendGrid::Mail.new
    mail.from = Email.new(email: 'notifier.asear@gmail.com')
    personalization = Personalization.new
    #personalization.add_to(Email.new(email: receiver.to_s, name: 'user prueba'))
    receiver = receiver.class == Array ? receiver : receiver.split(" ")
    receiver.each do |email|
      personalization.add_to(Email.new(email: email.to_s, name: email.to_s))
    end
    mail.add_personalization(personalization)
    mail.subject = subject
    mail.add_content(Content.new(
      type: 'text/html',
      value: ApplicationController.render(
        template: template,
        layout: nil,
        locals: {
          object0: args[0], object1: args[1], object2: args[2]
        }
      )))

    fileadd = fpath.to_s + fname.to_s
    if fileadd.present?
      attachment = SendGrid::Attachment.new
      attachment.content = Base64.strict_encode64(File.open(fileadd, 'rb').read)
      attachment.type = 'application/pdf'
      attachment.filename = fname
      attachment.disposition = 'attachment'
      attachment.content_id = 'Reports Sheet'
      mail.add_attachment(attachment)
    end
    sg = SendGrid::API.new(api_key: '')
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    return response
  end

  # Descripcion: Metodo para notificarle a los usuarios que cuentan con agenda
  # Fecha: 22-09-2022
  # Autor: AFP
  def sendEmailFormulario(receiver, subject, template, fpath, fname, *args)
    begin
      personasformulario = Personasformulario.find(args[0])
      response = Asearmail::SendmailServices.new.general(receiver, subject, template, fpath, fname, *args)
      Personasformulario.where(id: personasformulario.id).update_all(notificacion: 'ENVIADO', status_envio: response.status_code, body: 'Asearmail::SendmailServices.new.sendEmailFormulario: Enviado con exito')
      Personasformulariosmensaje.create(personasformulario_id: personasformulario.id, tipo: 'CORREO ELECTRONICO', estado: 'ENVIADO', estado_sendgrid: response.status_code, body: 'Asearmail::SendmailServices.new.sendEmailFormulario: Enviado con exito', registro: personasformulario.correo)
    rescue Exception => ex
      Personasformulario.where(id: personasformulario.id).update_all(status_envio: response.status_code, body: "Error Sygmail::SendmailServices.new.sendEmailFormulario: " + ex.message[0..1000].to_s)
      Personasformulariosmensaje.create(personasformulario_id: personasformulario.id, tipo: 'CORREO ELECTRONICO', estado: 'FALLIDO', estado_sendgrid: response.status_code, body: "Error Sygmail::SendmailServices.new.sendEmailFormulario: " + ex.message[0..1000].to_s, registro: personasformulario.correo)
    end
  end

  def sendEmailCodigo(receiver, subject, template, fpath, fname, *args)
    begin
      response = Asearmail::SendmailServices.new.general(receiver, subject, template, fpath, fname, *args)
    rescue Exception => ex
      nil
    end
  end

  def notificacionEmails(receiver, subject, template, fpath, fname, *args)
    begin
      response = Asearmail::SendmailServices.new.general(receiver, subject, template, fpath, fname, *args)
    rescue Exception => ex
      puts ex.message[0..1000].to_s
    end
  end

end
