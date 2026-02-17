class WsAportesController < ApplicationController
  protect_from_forgery with: :null_session

  #before_action :authenticate_user!, except: [:token_control]

  require 'uri'
  require 'net/http'
  require 'open-uri'
  require 'net/https'
  require "json"
  extend WsHelper

  # ********************************************************************************
  # ------------------- INICIA PROCESO DE ALEGRA - 18-Junio-2022 -------------------
  # # ******************************************************************************

  # Descripcion: Control de Acceso - Token
  # Fecha Creacion: 18-Junio-2022
  # Autor: AFP
  # https://www.aportesenlinea.com
  def self.token_control
    begin
      portafolio = Portafolio.find(1)
      url = URI(portafolio.aportes_url.to_s)
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE # Metodo para cuando se genera el error - OpenSSL::SSL::SSLError Exception: SSL_connect returned=1 errno=0 state=error: wrong version number
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["Anon"] = "Mareigua.Fanaia"
      request.body = JSON.dump({ "data": [{ "NombreUsuario": "#{portafolio.aportes_username}", "Password": "#{portafolio.aportes_contrasena}", "Aplicacion": "#{portafolio.aportes_aplicacion}" }] })
      response = https.request(request)
      retData = JSON.parse response.body
      logger.error('---------------------------------------------------------------------' + retData["data"].to_s + ' ---------------------------------')
      return retData["data"]
    rescue Exception => e
      logger.error('************************************************* error token ******************' + e.message[0..255].to_s)
      Erroresaporte.create(metodo: 'TOKEN', error: e.message[0..255].to_s)
    end
  end

  # Descripcion: Servicio de envio de novedades
  # Fecha Creacion: 24-Agosto-2022
  # Autor: AFP
  # Ejemplo: WsAportesController.creacion_novedades(1, 31, 191, 305)
  def self.creacion_masiva_novedades(portafolio_id, periodosliquidacion_id, contrato_id, contratosgrupo_id)
    Objeto.find_by_sql("select n.id as contratospernovedadid, n.contratospersona_id as contratospersonaid, c.contratosperfecha_id, f.registro_aportes_linea
                          from contratospernominas c, contratospersonas p, contratospernovedades n, tiposnovedades t, contratosperfechas f
                          where c.periodosliquidacion_id = #{periodosliquidacion_id}
                          and  c.contrato_id = #{contrato_id}
                          and  c.contratosgrupo_id = #{contratosgrupo_id}
                          and  c.estado = 'CONSOLIDADO'
                          and  c.contratospersona_id = p.id
                          and  c.id = n.contratospernomina_id
                          and  c.contratosperfecha_id = f.id
                          and  n.registro_aportes_linea is null
                          and  n.tiposnovedad_id = t.id
                          and  t.tiposnaporte_id is not null").each do |dato|
      #contratospersona = Contratospersona.find(dato.contratospersonaid)
      #if !dato.registro_aportes_linea.present?
      #  WsAportesController.creacion_cotizante_individual(portafolio_id, dato.contratosperfecha_id) # Crea el cotizante al momento de crear la novedad.
      #end
      WsAportesController.endpoint_universal_novedades_aportes(dato.contratospernovedadid, portafolio_id)
    end
  end

  # Descripcion: Creacion de cotizante Individual
  # Fecha Creacion: 29-Agosto-2022
  # Autor: AFP
  def self.creacion_cotizante_individual(isportafolio, contratosperfechaid)
    portafolio = Portafolio.find(isportafolio)
    cp = Contratosperfecha.find(contratosperfechaid)
    token = self.token_control rescue nil
    puts "INGRESA METODO creacion_cotizante_individual ---------- " + token.to_s
    if token
      url = URI("https://marketplace.aportesenlinea.com/Fanaia.Servicios.Fachada/api/Cotizantes/CrearCotizante")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE # Metodo para cuando error - OpenSSL::SSL::SSLError Exception: SSL_connect returned=1 errno=0 state=error: wrong version number
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["Anon"] = "Mareigua.Fanaia"
      request["Token"] = "#{token}"
      request.body = JSON.dump({
                                 "data": [
                                   {
                                     "Aportante":
                                       [
                                         {
                                           "TipoIdAportante": "#{portafolio.aportes_tipoidaportante}",
                                           "NumeroIdAportante": "#{portafolio.aportes_numeroidaportante}",
                                           "SucursalPrincipal": "#{cp.contratosgrupo.codigo_aportesenlinea.to_s}",
                                           "Cotizante": [
                                             {
                                               "TipoIdCotizante": "#{cp.contratospersona.aportes_TipoIdAportante}",
                                               "NumeroIdCotizante": "#{cp.contratospersona.identificacion}",
                                               "TipoCotizante": "1",
                                               "SubTipoCotizante": "0",
                                               "PrimerApellido": "#{cp.contratospersona.apellidos.strip.capitalize rescue nil}",
                                               "SegundoApellido": "#{WsAportesController.show_segundo_apellido(cp.contratospersona.apellido_segundo)}",
                                               "PrimerNombre": "#{cp.contratospersona.nombres.strip.capitalize.split[0] rescue nil}",
                                               "SegundoNombre": "#{WsAportesController.show_segundo_nombre(cp.contratospersona.nombres) rescue nil}",
                                               "Celular": "#{cp.contratospersona.movil rescue nil }",
                                               "Correo": "#{cp.contratospersona.correo.downcase rescue nil }",
                                               "CodigoSucursal": "#{cp.contratosgrupo.codigo_aportesenlinea rescue nil}",
                                               "CentroTrabajo": "#{cp.contratospersona.centro_aporte_linea rescue nil}", #contratosgrupos
                                               "ColombianoExterior": "false",
                                               "FechaResidenciaExterior": "",
                                               "CodigoAdmAFP": "#{Iparametro.where("campo = 'fondo_pension' and descripcion = '#{cp.contratospersona.fondo_pension}'").first.codigo_aportes rescue nil}",
                                               "CodigoAdmEPS": "#{Iparametro.where("campo = 'eps' and descripcion = '#{cp.contratospersona.eps}'").first.codigo_aportes rescue nil}", # Preguntar sobre el proceso
                                               "CodigoAdmARL": "#{Iparametro.where("campo = 'arl' and descripcion = '#{cp.contratospersona.arl}'").first.codigo_aportes rescue nil}",
                                               "TarifaARL": "",
                                               "Salario": cp.contratoscargo.salario.to_i,
                                               "SalarioIntegral": "false",
                                               "FechaIngreso": "#{cp.fecha_inicio}",
                                               "FechaRetiro": "#{cp.fecha_fin}",
                                               "GrupoPoblacional": "",
                                               "IBCSenaICBF": 0,
                                               "SalarioVariable": "false",
                                               "ClaseAltoRiesgo": "1",
                                               "ValorUPC": 0,
                                               "AporteOpcionalARL": "false",
                                               "AporteOpcionalCCF": "false",
                                               "CodigoAdmCCF": "#{Iparametro.where("campo = 'caja_compensacion' and descripcion = '#{cp.contratospersona.caja_compensacion}'").first.codigo_aportes rescue nil}",
                                               "TarifaCCF": "",
                                               "ExoneradoParafiscalesSalud": "false"
                                             }
                                           ]
                                         }
                                       ]
                                   }
                                 ]
                               }
      )

      response = https.request(request)
      retData = JSON.parse response.body
      puts "CREACION COTIZANTE INDIVIDUAL- #{retData}"
      if retData["mensajes"][0].present?
        cp.errores_aportes_linea = retData["mensajes"][0]["Texto"].to_s
        cp.save(validate: false)
      else
        cp.registro_aportes_linea = "#{retData["data"][0]} - #{Time.now}"
        cp.errores_aportes_linea = nil
        cp.save(validate: false)
        WsAportesController.nov_ingreso(cp.id, isportafolio)
      end
    else
      cp.errores_aportes_linea = 'Error con el token de acceso'
      cp.save(validate: false)
    end
  end

  def self.nov_ingreso(contratosperfechaId, portafolioid)
    contratosperfecha = Contratosperfecha.find(contratosperfechaId)
    portafolio = Portafolio.find(portafolioid)
    token = self.token_control rescue nil
    puts "INGRESA METODO nov_ingreso ---------- " + token
    if token
      url = URI("#{portafolio.aportes_url_novedades}")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE # Metodo para cuando se genera el error - OpenSSL::SSL::SSLError Exception: SSL_connect returned=1 errno=0 state=error: wrong version number
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["Anon"] = "Mareigua.Fanaia"
      request["Token"] = "#{token}"
      request.body = JSON.dump({
                                 "data": [
                                   {
                                     "Aportante": {
                                       "TipoIdAportante": "#{portafolio.aportes_tipoidaportante}",
                                       "NumeroIdAportante": "#{portafolio.aportes_numeroidaportante}",
                                       "SucursalPrincipal": "#{contratosperfecha.contratosgrupo.codigo_aportesenlinea}",
                                     },
                                     "Novedades": [
                                       {
                                         "TipoNovedad": "ING",
                                         "SubTipoNovedad": "X",
                                         "Periodo": "#{contratosperfecha.fecha_inicio.strftime("%Y-%m")}",
                                         "FechaInicial": "#{contratosperfecha.fecha_inicio.strftime("%Y-%m-%d")}",
                                         "TipodeDocumento": "#{contratosperfecha.contratospersona.aportes_TipoIdAportante}",
                                         "NumerodeDocumento": "#{contratosperfecha.contratospersona.identificacion}",
                                         "RecalcularValor": false
                                       }
                                     ]
                                   }
                                 ]
                               })

      response = https.request(request)
      retData = JSON.parse response.body
      puts "CREACION NOVEDAD INGRESO - #{retData}"
      if retData["mensajes"][0].present?
        contratosperfecha.error_aportes_ingreso = retData["mensajes"][0]["Texto"].to_s
        contratosperfecha.save(validate: false)
      else
        contratosperfecha.registro_aportes_ingreso = "#{retData["data"][0]} - #{Time.now}"
        contratosperfecha.error_aportes_ingreso = nil
        contratosperfecha.save(validate: false)
      end
    else
      contratosperfecha.error_aportes_ingreso = 'Error con el token de acceso'
      contratosperfecha.save(validate: false)
    end
  end

  def self.nov_retiro(contratosperfechaId, portafolioid)
    contratosperfecha = Contratosperfecha.find(contratosperfechaId)
    portafolio = Portafolio.find(portafolioid)
    token = self.token_control rescue nil
    puts "INGRESA METODO nov_retiro ---------- " + token
    if token
      url = URI("#{portafolio.aportes_url_novedades}")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE # Metodo para cuando se genera el error - OpenSSL::SSL::SSLError Exception: SSL_connect returned=1 errno=0 state=error: wrong version number
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["Anon"] = "Mareigua.Fanaia"
      request["Token"] = "#{token}"
      request.body = JSON.dump({
                                 "data": [
                                   {
                                     "Aportante": {
                                       "TipoIdAportante": "#{portafolio.aportes_tipoidaportante}",
                                       "NumeroIdAportante": "#{portafolio.aportes_numeroidaportante}",
                                       "SucursalPrincipal": "#{contratosperfecha.contratosgrupo.codigo_aportesenlinea}",
                                     },
                                     "Novedades": [
                                       {
                                         "TipoNovedad": "RET",
                                         "SubTipoNovedad": "X",
                                         "Periodo": "#{contratosperfecha.fecha_fin.strftime("%Y-%m")}",
                                         "FechaFinal": "#{contratosperfecha.fecha_fin.strftime("%Y-%m-%d")}",
                                         "TipodeDocumento": "#{contratosperfecha.contratospersona.aportes_TipoIdAportante}",
                                         "NumerodeDocumento": "#{contratosperfecha.contratospersona.identificacion}",
                                         "RecalcularValor": false
                                       }
                                     ]
                                   }
                                 ]
                               })
      response = https.request(request)
      retData = JSON.parse response.body
      puts "CREACION NOVEDAD RETIRO - #{retData}"
      if retData["mensajes"][0].present?
        contratosperfecha.error_aportes_retiro = retData["mensajes"][0]["Texto"].to_s
        contratosperfecha.save(validate: false)
      else
        contratosperfecha.registro_aportes_retiro = "#{retData["data"][0]} - #{Time.now}"
        contratosperfecha.error_aportes_retiro = nil
        contratosperfecha.save(validate: false)
      end
    else
      contratosperfecha.error_aportes_retiro = 'Error con el token de acceso'
      contratosperfecha.save(validate: false)
    end
  end

  def self.nov_vaciones

  end

  # Descripcion: Servicios de otras novedades (Retiro)
  # Fecha Creacion: 29-Agosto-2022
  # Autor: AFP
  def self.otras_novedades_aportes(contratosperfechaid, tiposnaporteid, idtablareferencia, portafolioid)
    portafolio = Portafolio.find(portafolioid)
    contratosperfecha = Contratosperfecha.find(contratosperfechaid)
    tiposnaporte = Tiposnaporte.find(tiposnaporteid) # codigo, subtipo, descripcion
    token = self.token_control rescue nil
    puts "INGRESA METODO otras_novedades_aportes ---------- " + token
    if token
      url = URI("#{portafolio.aportes_url_novedades}")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE # Metodo para cuando se genera el error - OpenSSL::SSL::SSLError Exception: SSL_connect returned=1 errno=0 state=error: wrong version number
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["Anon"] = "Mareigua.Fanaia"
      request["Token"] = "#{token}"
      if tiposnaporte.tipo == 'RET'
        contratosperliquidacion = Contratosperliquidacion.find(idtablareferencia)
        solicitudesretiro = Solicitudesretiro.find_by_contratosperliquidacion_id(contratosperliquidacion.id)
        WsAportesController.creacion_cotizante_individual(portafolio.id, contratosperfecha.id) # Crea el cotizante al momento de crear la novedad.
        request.body = JSON.dump({
                                   "data": [
                                     {
                                       "Aportante": {
                                         "TipoIdAportante": "#{portafolio.aportes_tipoidaportante}",
                                         "NumeroIdAportante": "#{portafolio.aportes_numeroidaportante}",
                                         "SucursalPrincipal": "#{contratosperfecha.contratosgrupo.codigo_aportesenlinea}",
                                       },
                                       "Novedades": [
                                         {
                                           "TipoNovedad": "#{tiposnaporte.tipo}",
                                           "SubTipoNovedad": "#{tiposnaporte.subtipo}",
                                           "ValorTotal": contratosperliquidacion.total,
                                           "AportesParafiscales": false,
                                           "Periodo": "#{solicitudesretiro.fecha.strftime("%Y-%m")}",
                                           "FechaFinal": "#{solicitudesretiro.fecha.strftime("%Y-%m-%d")}",
                                           "TipodeDocumento": "#{solicitudesretiro.contratospersona.aportes_TipoIdAportante}",
                                           "NumerodeDocumento": "#{solicitudesretiro.contratospersona.identificacion}"
                                         }
                                       ]
                                     }
                                   ]
                                 })
        response = https.request(request)
        retData = JSON.parse response.body
        puts "CREACION NOVEDAD 1 a 1- #{retData}"
        if retData["mensajes"][0].present?
          contratosperliquidacion.errores_aportes_linea = retData["mensajes"][0]["Texto"].to_s
          contratosperliquidacion.save(validate: false)
        else
          contratosperliquidacion.registro_aportes_linea = "#{retData["data"][0]} - #{Time.now}"
          contratosperliquidacion.errores_aportes_linea = nil
          contratosperliquidacion.save(validate: false)
        end
      elsif tiposnaporte.tipo == 'VAC'
        contratospervacacion = Contratospervacacion.find(idtablareferencia)
        request.body = JSON.dump({
                                   "data": [
                                     {
                                       "Aportante": {
                                         "TipoIdAportante": "#{portafolio.aportes_tipoidaportante}",
                                         "NumeroIdAportante": "#{portafolio.aportes_numeroidaportante}",
                                         "SucursalPrincipal": "#{contratosperfecha.contratosgrupo.codigo_aportesenlinea}",
                                       },
                                       "Novedades": [
                                         {
                                           "TipoNovedad": "#{tiposnaporte.tipo}",
                                           "SubTipoNovedad": "#{tiposnaporte.subtipo}",
                                           "ValorTotal": contratospervacacion.valor_total,
                                           "AportesParafiscales": false,
                                           "Periodo": "#{contratospervacacion.fecha_inicio.strftime("%Y-%m")}",
                                           "FechaInicial": "#{contratospervacacion.fecha_inicio.strftime("%Y-%m-%d")}",
                                           "FechaFinal": "#{contratospervacacion.fecha_fin.strftime("%Y-%m-%d")}",
                                           "TipodeDocumento": "#{contratospervacacion.contratospersona.aportes_TipoIdAportante}",
                                           "NumerodeDocumento": "#{contratospervacacion.contratospersona.identificacion}"
                                         }
                                       ]
                                     }
                                   ]
                                 })
        response = https.request(request)
        retData = JSON.parse response.body
        puts "CREACION NOVEDAD 1 a 1- #{retData}"
        if retData["mensajes"][0].present?
          contratospervacacion.errores_aportes_linea = retData["mensajes"][0]["Texto"].to_s
          contratospervacacion.save(validate: false)
        else
          contratospervacacion.registro_aportes_linea = "#{retData["data"][0]} - #{Time.now}"
          contratospervacacion.errores_aportes_linea = nil
          contratospervacacion.save(validate: false)
        end
      end
    else
      contratospervacacion.errores_aportes_linea = 'Error con el token de acceso'
      contratospervacacion.save(validate: false)
    end
  end

  # Descripcion: Servicio de envio de novedades
  # Fecha Creacion: 24-Agosto-2022
  # Autor: AFP
  # Ejemplo: WsAportesController.creacion_novedades(1, 31, 191, 305)
  def self.otras_novedades_masivas(portafolio_id, consecutivo, tiponovedad)
    # Solo el tiponovedad recibe VAC o RET
    if tiponovedad.to_s == 'RET' # Retiro novedad
      Objeto.find_by_sql("select c.id as idtablareferencia , c.contratosperfecha_id
                      from solicitudesretiros s, contratosperliquidaciones c, contratosperfechas f
                      where s.consecutivo = #{consecutivo}
                      and   s.contratosperliquidacion_id = c.id
                      and   c.contratosperfecha_id = f.id
                      and   f.trasladado = 'NO'
                      and   c.registro_aportes_linea is null").each do |dato|
        WsAportesController.otras_novedades_aportes(dato.contratosperfecha_id, 4, dato.idtablareferencia, portafolio_id) # Pendiente de la tabla de creacion
      end
    elsif tiponovedad.to_s == 'VAC' # Vacaciones novedad
      Objeto.find_by_sql("select c.id as idtablareferencia , c.contratosperfecha_id
                      from contratospervacaciones c
                      where c.consecutivo = #{consecutivo}
                      and   c.registro_aportes_linea is null").each do |dato|
        WsAportesController.otras_novedades_aportes(dato.contratosperfecha_id, 16, dato.idtablareferencia, portafolio_id) # Pendiente de la tabla de creacion
      end
    end
  end

  def self.prueba_envio
    Objeto.find_by_sql("select contratospernovedad_id, tiposnovedad_id from pruebanovedades where observacion is null order by tiposnovedad_id asc").each do |dato|
      WsAportesController.endpoint_universal_novedades_aportes(dato.contratospernovedad_id, 1)
    end
  end

  # Descripcion: Servicio universal novedades 1 a 1
  # Fecha Creacion: 29-Agosto-2022
  # Autor: AFP
  def self.endpoint_universal_novedades_aportes(contratospernovedadid, portafolioid)
    portafolio = Portafolio.find(portafolioid)
    contratospernovedad = Contratospernovedad.find(contratospernovedadid)
    if contratospernovedad.numero.to_i > 0 and contratospernovedad.valor_novedad.to_i == 0
      vlrNovedad = 1
    else
      vlrNovedad = contratospernovedad.valor_novedad.to_i
    end
    i = 1
    array = []
    while i <= 81
      valida = eval("contratospernovedad.fecha#{i}") rescue nil
      if valida.present?
        array << valida
      end
      i += 1
    end

    begin
      #Fabian Prueba
      token = self.token_control rescue nil
      puts "INGRESA METODO endpoint_universal_novedades_aportes ---------- " + token
      if token.present?
        url = URI("#{portafolio.aportes_url_novedades}")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        https.verify_mode = OpenSSL::SSL::VERIFY_NONE # Metodo para cuando se genera el error - OpenSSL::SSL::SSLError Exception: SSL_connect returned=1 errno=0 state=error: wrong version number
        request = Net::HTTP::Post.new(url)
        request["Content-Type"] = "application/json"
        request["Anon"] = "Mareigua.Fanaia"
        request["Token"] = "#{token}"
        request.body = JSON.dump({
                                   "data": [
                                     {
                                       "Aportante": {
                                         "TipoIdAportante": "#{portafolio.aportes_tipoidaportante}",
                                         "NumeroIdAportante": "#{portafolio.aportes_numeroidaportante}",
                                         "SucursalPrincipal": "#{contratospernovedad.contratosgrupo.codigo_aportesenlinea}",
                                       },
                                       "Novedades": [
                                         if ["LMA"].include?(contratospernovedad.tiposnovedad.tiposnaporte.tipo)
                                           {
                                             "TipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.tipo}",
                                             "Periodo": "#{contratospernovedad.fecha.strftime("%Y-%m")}",
                                             "FechaInicial": "#{array[0].strftime("%Y-%m-%d")}",
                                             "FechaFinal": "#{array[-1].strftime("%Y-%m-%d")}",
                                             "ValorTotal": vlrNovedad,
                                             "SubTipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.subtipo}",
                                             "AportesParafiscales": false,
                                             "TipodeDocumento": "#{contratospernovedad.contratospersona.aportes_TipoIdAportante}",
                                             "NumerodeDocumento": "#{contratospernovedad.contratospersona.identificacion}",
                                             "RecalcularValor": false
                                           }
                                         elsif ["VST"].include?(contratospernovedad.tiposnovedad.tiposnaporte.tipo)
                                           {
                                             "TipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.tipo}",
                                             "ValorTotal": vlrNovedad,
                                             "Periodo": "#{contratospernovedad.fecha.strftime("%Y-%m")}",
                                             "TipodeDocumento": "#{contratospernovedad.contratospersona.aportes_TipoIdAportante}",
                                             "NumerodeDocumento": "#{contratospernovedad.contratospersona.identificacion}",
                                             "RecalcularValor": false
                                           }
                                         elsif ["VSP"].include?(contratospernovedad.tiposnovedad.tiposnaporte.tipo)
                                           {
                                             "TipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.tipo}",
                                             "ValorTotal": vlrNovedad,
                                             "Periodo": "#{contratospernovedad.fecha.strftime("%Y-%m")}",
                                             "FechaInicial": "#{array[0].strftime("%Y-%m-%d")}",
                                             "TipodeDocumento": "#{contratospernovedad.contratospersona.aportes_TipoIdAportante}",
                                             "NumerodeDocumento": "#{contratospernovedad.contratospersona.identificacion}",
                                             "RecalcularValor": false
                                           }
                                         elsif ["VIP"].include?(contratospernovedad.tiposnovedad.tiposnaporte.tipo)
                                           {
                                             "TipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.tipo}",
                                             "ValorTotal": vlrNovedad,
                                             "Periodo": "#{contratospernovedad.fecha.strftime("%Y-%m")}",
                                             "TipodeDocumento": "#{contratospernovedad.contratospersona.aportes_TipoIdAportante}",
                                             "NumerodeDocumento": "#{contratospernovedad.contratospersona.identificacion}",
                                             "RecalcularValor": false
                                           }
                                         elsif ["IRL"].include?(contratospernovedad.tiposnovedad.tiposnaporte.tipo)
                                           {
                                             "TipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.tipo}",
                                             "Periodo": "#{contratospernovedad.fecha.strftime("%Y-%m")}",
                                             "AportesParafiscales": false,
                                             "FechaInicial": "#{array[0].strftime("%Y-%m-%d")}",
                                             "FechaFinal": "#{array[-1].strftime("%Y-%m-%d")}",
                                             "ValorTotal": vlrNovedad,
                                             "TipodeDocumento": "#{contratospernovedad.contratospersona.aportes_TipoIdAportante}",
                                             "NumerodeDocumento": "#{contratospernovedad.contratospersona.identificacion}",
                                             "RecalcularValor": false
                                           }
                                         elsif ["SLN"].include?(contratospernovedad.tiposnovedad.tiposnaporte.tipo)
                                           {
                                             "TipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.tipo}",
                                             "Periodo": "#{contratospernovedad.fecha.strftime("%Y-%m")}",
                                             "FechaInicial": "#{array[0].strftime("%Y-%m-%d")}",
                                             "FechaFinal": "#{array[-1].strftime("%Y-%m-%d")}",
                                             "ValorTotal": vlrNovedad,
                                             "TarifaTotalPension": 0,
                                             "TipodeDocumento": "#{contratospernovedad.contratospersona.aportes_TipoIdAportante}",
                                             "NumerodeDocumento": "#{contratospernovedad.contratospersona.identificacion}",
                                             "RecalcularValor": false
                                           }
                                         elsif ["VAC"].include?(contratospernovedad.tiposnovedad.tiposnaporte.tipo)
                                           {
                                             "TipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.tipo}",
                                             "SubTipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.subtipo}",
                                             "Periodo": "#{contratospernovedad.fecha.strftime("%Y-%m")}",
                                             "FechaInicial": "#{array[0].strftime("%Y-%m-%d")}",
                                             "FechaFinal": "#{array[-1].strftime("%Y-%m-%d")}",
                                             "ValorTotal": vlrNovedad,
                                             "TipodeDocumento": "#{contratospernovedad.contratospersona.aportes_TipoIdAportante}",
                                             "NumerodeDocumento": "#{contratospernovedad.contratospersona.identificacion}",
                                             "RecalcularValor": false
                                           }
                                         elsif ["VCT"].include?(contratospernovedad.tiposnovedad.tiposnaporte.tipo)
                                           {
                                             "TipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.tipo}",
                                             "Periodo": "#{contratospernovedad.fecha.strftime("%Y-%m")}",
                                             "FechaInicial": "#{array[0].strftime("%Y-%m-%d")}",
                                             "TipodeDocumento": "#{contratospernovedad.contratospersona.aportes_TipoIdAportante}",
                                             "NumerodeDocumento": "#{contratospernovedad.contratospersona.identificacion}",
                                             "NuevoCentroTrabajo": "001",
                                             "RecalcularValor": false
                                           }
                                         elsif ["CTC"].include?(contratospernovedad.tiposnovedad.tiposnaporte.tipo)
                                           {
                                             "TipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.tipo}",
                                             "Periodo": "#{contratospernovedad.fecha.strftime("%Y-%m")}",
                                             "DiaInicial": "10",
                                             "SinonimoNuevoTipoCotizante": 1,
                                             "CodigoAdmAfpNueva": "230301",
                                             "TipodeDocumento": "#{contratospernovedad.contratospersona.aportes_TipoIdAportante}",
                                             "NumerodeDocumento": "#{contratospernovedad.contratospersona.identificacion}",
                                             "RecalcularValor": false
                                           }
                                         elsif ["TPR"].include?(contratospernovedad.tiposnovedad.tiposnaporte.tipo)
                                           {
                                             "TipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.tipo}",
                                             "Periodo": "#{contratospernovedad.fecha.strftime("%Y-%m")}",
                                             "DuracionTotal": contratospernovedad.numero.to_i,
                                             "TipodeDocumento": "#{contratospernovedad.contratospersona.aportes_TipoIdAportante}",
                                             "NumerodeDocumento": "#{contratospernovedad.contratospersona.identificacion}",
                                             "RecalcularValor": false
                                           }
                                         elsif ["RET"].include?(contratospernovedad.tiposnovedad.tiposnaporte.tipo)
                                           {
                                             "TipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.tipo}",
                                             "SubTipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.subtipo}",
                                             "Periodo": "#{contratospernovedad.fecha.strftime("%Y-%m")}",
                                             "FechaFinal": "#{array[-1].strftime("%Y-%m-%d")}",
                                             "TipodeDocumento": "#{contratospernovedad.contratospersona.aportes_TipoIdAportante}",
                                             "NumerodeDocumento": "#{contratospernovedad.contratospersona.identificacion}",
                                             "RecalcularValor": false
                                           }
                                         elsif ["IGE"].include?(contratospernovedad.tiposnovedad.tiposnaporte.tipo) # ok
                                           {
                                             "TipoNovedad": "#{contratospernovedad.tiposnovedad.tiposnaporte.tipo}",
                                             "Periodo": "#{contratospernovedad.fecha.strftime("%Y-%m")}",
                                             "AportesParafiscales": false,
                                             "SalarioCompleto": false,
                                             "FechaInicial": "#{array[0].strftime("%Y-%m-%d")}",
                                             "FechaFinal": "#{array[-1].strftime("%Y-%m-%d")}",
                                             "ValorTotal": vlrNovedad,
                                             "TipodeDocumento": "#{contratospernovedad.contratospersona.aportes_TipoIdAportante}",
                                             "NumerodeDocumento": "#{contratospernovedad.contratospersona.identificacion}",
                                             "RecalcularValor": false
                                           }
                                         end
                                       ]
                                     }
                                   ]
                                 })
        response = https.request(request)
        retData = JSON.parse response.body
        puts "CREACION NOVEDAD 1 a 1- #{retData}"
        #ActiveRecord::Base.connection.execute("update pruebanovedades set observacion = '#{retData}' where contratospernovedad_id = #{contratospernovedadid}")
        if retData["mensajes"][0].present?
          contratospernovedad.errores_aportes_linea = retData["mensajes"][0]["Texto"].to_s
          contratospernovedad.save(validate: false)
        else
          contratospernovedad.registro_aportes_linea = "#{retData["data"][0]} - #{Time.now}"
          contratospernovedad.errores_aportes_linea = nil
          contratospernovedad.save(validate: false)
        end
      else
        contratospernovedad.errores_aportes_linea = 'Error con el token de acceso'
        contratospernovedad.save(validate: false)
      end
    rescue Exception => e
      contratospernovedad.errores_aportes_linea = 'Error con el token de acceso. '+ e.message[0..255].to_s
      contratospernovedad.save(validate: false)
    end
  end

  # Descripcion: Servicio certificado de aportes
  # Fecha Creacion: 18-Julio-2022
  # Autor: AFP
  def self.certificado_aportes(contratospersona, isportafolio)
    portafolio = Portafolio.find(isportafolio)
    token = self.token_control rescue nil
    if token
      url = URI("#{portafolio.aportes_url_certificado}")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE # Metodo para cuando se genera el error - OpenSSL::SSL::SSLError Exception: SSL_connect returned=1 errno=0 state=error: wrong version number
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["Anon"] = "Mareigua.Fanaia"
      request["Token"] = "#{token}"
      request.body = JSON.dump({
                                 "certificadoAportes": {
                                   "TipoIdentificacionEmpleado": "#{contratospersona.aportes_TipoIdAportante}",
                                   "NumeroIdentificacionEmpleado": "#{contratospersona.identificacion}",
                                   "PeriodoDesde": 1656651600, # Metodo para convertir los datos pendiente de saber donde se generan las fechas
                                   "PeriodoHasta": 1659157200,
                                   "FormatoReporte": 1, # Tipo 1 es pdf
                                   "LlaveApertura": ""
                                 }
                               })
      response = https.request(request)
      puts response.read_body
    end
  end

  # Descripcion: Metodo para adecuacion la creacion de cotizante
  # Fecha Creacion: 24-Agosto-2022
  # Autor: AFP
  def self.show_segundo_apellido(dato)
    dato.present? ? dato.strip.capitalize : nil
  end

  # Descripcion: Metodo para adecuacion la creacion de cotizante
  # Fecha Creacion: 24-Agosto-2022
  # Autor: AFP
  def self.show_segundo_nombre(dato)
    dato.present? ? dato.strip.capitalize.split[1] : nil
  end

end


