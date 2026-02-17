class Asearsms::SendsmsServices
  def send_sms_formulario(idRegistro, mensajeDescripcion)
    personasformulario = Personasformulario.find(idRegistro)
    WsController.smscolombiared(personasformulario.celular.to_s,mensajeDescripcion.to_s)
    begin
      Personasformulariosmensaje.create(personasformulario_id: personasformulario.id, tipo: 'SMS', estado: 'ENVIADO', estado_sendgrid: '202', body: 'PersonasformulariosController:envio_sms: Enviado con exito.', registro: personasformulario.celular)
    rescue Exception => ex
      Personasformulariosmensaje.create(personasformulario_id: personasformulario.id, tipo: 'SMS', estado: 'FALLIDO', estado_sendgrid: "999", body: "Error PersonasformulariosController:envio_sms: " + ex.message[0..1000].to_s, registro: personasformulario.celular)
    end
  end

  def send_sms_formulario2(idRegistro, mensajeDescripcion)
    personasformulario = Personasformulario.find(idRegistro)
    WsController.smscolombiared(personasformulario.celular2.to_s,mensajeDescripcion.to_s)
    begin
      Personasformulariosmensaje.create(personasformulario_id: personasformulario.id, tipo: 'SMS', estado: 'ENVIADO', estado_sendgrid: '202', body: 'PersonasformulariosController:envio_sms: Enviado con exito.', registro: personasformulario.celular)
    rescue Exception => ex
      Personasformulariosmensaje.create(personasformulario_id: personasformulario.id, tipo: 'SMS', estado: 'FALLIDO', estado_sendgrid: "999", body: "Error PersonasformulariosController:envio_sms: " + ex.message[0..1000].to_s, registro: personasformulario.celular)
    end
  end

  def send_sms_firma(idRegistro, mensajeDescripcion)
    contratosperfecha = Contratosperfecha.find(idRegistro)
    WsController.smscolombiared(contratosperfecha.contratospersona.movil.to_s,mensajeDescripcion.to_s)
    begin
      contratosperfecha.status_sms = '202'
      contratosperfecha.body_sms = 'ContratosperfechasController:marcar_firma: Enviado con exito.'# +  req.to_json.to_s
      contratosperfecha.save(validate: false)
    rescue Exception => ex
      contratosperfecha.status_sms = '999'
      contratosperfecha.body_sms = "Error PersonasformulariosController:envio_sms: " + ex.message[0..1000].to_s
      contratosperfecha.save(validate: false)
    end
  end

  def send_sms_otp(idRegistro, mensajeDescripcion, ruta)
    contratosperfecha = Contratosperfecha.find(idRegistro)
    WsController.smscolombiared(contratosperfecha.contratospersona.movil.to_s,mensajeDescripcion.to_s)
    begin
      if ruta == 'otp1'
        contratosperfecha.status_sms_opt1 = '202'
        contratosperfecha.body_sms_otp1 = 'ContratosperfechasController:generar_otp: Enviado con exito.'
        contratosperfecha.save(validate: false)
      elsif  ruta == 'otp2'
        contratosperfecha.status_sms_opt2 = '202'
        contratosperfecha.body_sms_otp2 = 'ContratosperfechasController:generar_otp: Enviado con exito.'
        contratosperfecha.save(validate: false)
      end
    rescue Exception => ex
      if ruta == 'otp1'
        contratosperfecha.status_sms_opt1 = '999'
        contratosperfecha.body_sms_otp1 = "Error ContratosperfechasController:generar_otp: " + ex.message[0..1000].to_s
        contratosperfecha.save(validate: false)
      elsif  ruta == 'otp2'
        contratosperfecha.status_sms_opt2 = '999'
        contratosperfecha.body_sms_otp2 = "Error ContratosperfechasController:generar_otp: " + ex.message[0..1000].to_s
        contratosperfecha.save(validate: false)
      end
    end
  end

  def send_sms_users(idRegistro, mensajeDescripcion)
    user = User.find(idRegistro)
    WsController.smscolombiared(user.celular.to_s,mensajeDescripcion.to_s)
    begin
      User.where(id: idRegistro).update_all(observaciones: '202 - SMS-Enviado al Users: ')# +  req.to_json.to_s)
    rescue Exception => ex
      User.where(id: idRegistro).update_all(observaciones: '999 - ERROR-SMS-Enviado al Users: ' + ex.message[0..1000].to_s)
    end
  end

  def send_sms_inicio(idRegistro, mensajeDescripcion)
    dato = Contratospersona.find(idRegistro)
    WsController.smscolombiared(dato.movil.to_s,mensajeDescripcion.to_s)
  end

  #Asearsms::SendsmsServices.new.send_sms_procesos('','Prueba de envio')
  def send_sms_procesos(idMovil, mensajeDescripcion)
    WsController.smscolombiared(idMovil.to_s,mensajeDescripcion.to_s)
  end
end