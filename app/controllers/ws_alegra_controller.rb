class WsAlegraController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :authenticate_user!, except: [:enviar_nomina,:prueba]

  require 'uri'
  require 'net/https'
  require 'net/http'
  require 'openssl'
  require 'open-uri'
  extend WsHelper

  # ********************************************************************************
  # ------------------- INICIA PROCESO DE ALEGRA - 20-Abril-2022 -------------------
  # # ******************************************************************************

  # Descripcion: Servicio Crear Compañia en Alegra
  # Fecha Creacion: 24-Abril-2022
  # Autor: AFP
  def crear_empresa
    portafolio = Portafolio.find(params[:portafolio_id])
    url = URI(portafolio.url_crear_empresa_alegra.to_s)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Accept"] = "application/json"
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{portafolio.token_alegra}"
    request.body = JSON.dump({ "name": portafolio.name_alegra.to_s,
                               "identification": portafolio.identificacion_alegra.to_s,
                               "dv": portafolio.dv_alegra.to_s,
                               "useAlegraCertificate": true })
    response = https.request(request)
    retData = JSON.parse response.body
    portafolio.update(id_alegra: retData["company"]["id"], type_alegra: retData["company"]["type"], name_alegra: retData["company"]["name"], dv_alegra: retData["company"]["dv"])
    flash["notice"] = "Empresa Creada con exito"
    redirect_to portafolios_path
  end

  # Descripcion: Servicio Habilitar Compañia en Alegra
  # Fecha Creacion: 24-Abril-2022
  # Autor: AFP
  def habilitar_empresa
    portafolio = Portafolio.find(params[:portafolio_id])
    url = URI(portafolio.url_habilitar_empresa_alegra.to_s)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Accept"] = "application/json"
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{portafolio.token_alegra}"
    request.body = JSON.dump({
                               "type": "payrolls",
                               "governmentId": portafolio.governmentid_alegra.to_s,
                               "company": { "id": portafolio.id_alegra.to_s }
                             })

    response = https.request(request)
    retData = JSON.parse response.body
    if retData["testSet"]["status"] == "ACCEPTED"
      portafolio.update(habilita_alegra: 'S')
      flash["notice"] = "Empresa Habilitada con exito"
    else
      flash["warning"] = "Se presento un problema al habitar la empresa"
    end
    redirect_to portafolios_path
  end


  # Descripcion: Anulacion de nomina Electronica
  # Fecha Creacion: 10-Octubre-2023
  # Autor: AFP
  # Ejemplo:
  def self.anulacion_nomina(portafolio_id)# En caso de recibir mas parametros colocarlos aca
    portafolio = Portafolio.find(portafolio_id)
    idNominaElectronica = "aca debe de ir el id de la nomina que se va a anular"
    url = URI("https://sandbox-api.alegra.com/e-provider/col/v1/payrolls/#{idNominaElectronica}/cancel")
    request = Net::HTTP::Post.new(url)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)

    request["Accept"] = "application/json"
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{portafolio.token_alegra}"
    request.body = JSON.dump({
                               "prefix": "NEA", # Parametros que se deben de reemplazar
                               "number": "1" # Parametros que se deben de reemplazar
                             })
    response = https.request(request)
    retData = JSON.parse response.body
    # RECORDAR DONDE SE VA A GUARDAR LA RESPUESTA DE ESA ANULACION
    #portafolio.update(id_alegra: retData["company"]["id"], type_alegra: retData["company"]["type"], name_alegra: retData["company"]["name"], dv_alegra: retData["company"]["dv"])
    flash["notice"] = "Nomina Anulada con exito"
    redirect_to root_path
  end


  # Descripcion: Servicio de envio de Factura a Alegra
  # Fecha Creacion: 20-Abril-2022
  # Autor: AFP
  # Ejemplo: WsAlegraController.enviar_nomina(1,13,24,20)
  def self.enviar_nomina(portafolio_id, periodosliquidacion_id, contrato_id, contratosgrupo_id)
    #begin
      portafolio = Portafolio.find(portafolio_id)
      periodo = Periodosliquidacion.find(periodosliquidacion_id)
      nro_periodo = periodo.periodo_alegra # == 'QUINCENAL' ? 4 : 5 # Ver linea 212
      url = URI(portafolio.url_alegra.to_s)
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Accept"] = "application/json"
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{portafolio.token_alegra}"

      Contratospernomina.joins(:contratospersona)
                        .where("contratospernominas.periodosliquidacion_id = #{periodosliquidacion_id}
                                and contratospernominas.contrato_id = #{contrato_id}
                                and contratospernominas.contratosgrupo_id = #{contratosgrupo_id}
                                and contratospernominas.estado = 'CONSOLIDADO'
                                and contratospernominas.alegra_id is null")
                        .select("contratospersonas.identificacion, contratospersonas.nombres, contratospersonas.apellidos, contratospersonas.direccion, contratospersonas.banco, contratospersonas.tipo_cuenta, contratospersonas.cuenta_bancolombia,
                                (select fecha_inicio from contratosperfechas where id = contratospernominas.contratosperfecha_id) fchinicio,
                                contratospernominas.*")
                        .each do |contratospernomina|
        #begin
          request.body = JSON.dump({
                                    "company": {
                                      "id": "#{portafolio.id_alegra}",
                                      "name": "#{portafolio.name_alegra}",
                                      "identification": "#{portafolio.identificacion_alegra}",
                                      "dv": "#{portafolio.dv_alegra}",
                                      "type": "#{portafolio.type_alegra}",
                                      "useAlegraCertificate": true,
                                      "governmentStatus": {
                                        "invoices": "AUTHORIZED"
                                      },
                                      "webhooks": {}
                                    },
                                    "governmentData": {
                                      "Periodo": {
                                        "FechaIngreso": "#{contratospernomina.fchinicio}",
                                        "FechaLiquidacionInicio": "#{periodo.inicio}",
                                        "FechaLiquidacionFin": "#{periodo.fin}"
                                      },
                                      "LugarGeneracionXML": {
                                        "Pais": "CO", # Codigo del Pais
                                        "DepartamentoEstado": "05", # Codigo del departamento -  Antioquia
                                        "MunicipioCiudad": "05001", # Codigo del municipio - Medellín
                                        "Idioma": "es"
                                      },
                                      "InformacionGeneral": {
                                        "PeriodoNomina": "#{nro_periodo}",
                                        "TipoMoneda": "COP"
                                      },
                                      "Empleador": {
                                        "RazonSocial": "#{portafolio.name_alegra}",
                                        "NIT": portafolio.identificacion_alegra.to_i,
                                        "DV": portafolio.dv_alegra.to_i,
                                        "Pais": "CO", # Codigo del Pais
                                        "DepartamentoEstado": "05", # Codigo del departamento -  Antioquia
                                        "MunicipioCiudad": "05001", # Codigo del municipio - Medellín
                                        "Direccion": "#{portafolio.direccion}"
                                      },
                                      "Trabajador": {
                                        "TipoTrabajador": "01", # Verificar Linea 193
                                        "SubTipoTrabajador": "00", # Verificar Linea 207
                                        "AltoRiesgoPension": false,
                                        "TipoDocumento": "13", # Tipo de Documento - CC
                                        "NumeroDocumento": "#{contratospernomina.identificacion}",
                                        "PrimerApellido": "#{contratospernomina.nombres}",
                                        "SegundoApellido": "",
                                        "PrimerNombre": "#{contratospernomina.apellidos}",
                                        "OtrosNombres": "",
                                        "LugarTrabajoPais": "CO",
                                        "LugarTrabajoDepartamentoEstado": "05", # Codigo del departamento -  Antioquia
                                        "LugarTrabajoMunicipioCiudad": "05001", # Codigo del municipio - Medellín
                                        "LugarTrabajoDireccion": "#{contratospernomina.direccion}",
                                        "SalarioIntegral": false,
                                        "TipoContrato": "2", # Verificar Linea 211
                                        "Sueldo": contratospernomina.salario.to_i
                                      },
                                      "Pago": {
                                        "Forma": "1", # Verificar Linea 218
                                        "Metodo": "31", # Verificar Linea 222
                                        "Banco": "#{contratospernomina.banco}",
                                        "TipoCuenta": "#{contratospernomina.tipo_cuenta}",
                                        "NumeroCuenta": "#{contratospernomina.cuenta_bancolombia}"
                                      },
                                      "FechasPagos": {
                                        "FechaPago": [
                                          "#{periodo.fin}"
                                        ]
                                      },
                                      "Devengados": {
                                        "Basico": {
                                          "DiasTrabajados": contratospernomina.dias.to_i,
                                          "SueldoTrabajado": contratospernomina.salario.to_i
                                        }
                                      },
                                      "Deducciones": {
                                        "Salud": {
                                          "Porcentaje": 4,
                                          "Deduccion": contratospernomina.salud.to_i
                                        },
                                        "FondoPension": {
                                          "Porcentaje": 4,
                                          "Deduccion": contratospernomina.pension.to_i
                                        }
                                      },
                                      "Redondeo": 0,
                                      "DevengadosTotal": contratospernomina.nov_devengo.to_i,
                                      "DeduccionesTotal": contratospernomina.nov_deduccion.to_i,
                                      "ComprobanteTotal": contratospernomina.total.to_i
                                    },
                                    "prefix": "NE",
                                    "number": contratospernomina.id.to_i
                                  })
          response = https.request(request)
          retData = JSON.parse response.body
          if retData["errors"].present?
            contratospernomina.update(erros_alegra: retData["errors"][0]["message"])
          end

          if retData["payroll"].present?
            contratospernomina.update(alegra_id: retData["payroll"]["id"], alegra_cune: retData["payroll"]["cune"],
                                      alegra_date: retData["payroll"]["date"], alegra_xmlfilename: retData["payroll"]["xmlFileName"],
                                      alegra_zipfilename: retData["payroll"]["zipFileName"],
                                      alegra_qrcodecontent: retData["payroll"]["qrCodeContent"],
                                      alegra_signaturevalue: retData["payroll"]["signatureValue"],
                                      status_alegra: retData["payroll"]["status"],
                                      legalstatus_alegra: retData["payroll"]["legalStatus"],
                                      governmentresponse_code: retData["payroll"]["governmentResponse"]["code"],
                                      governmentresponse_message: retData["payroll"]["governmentResponse"]["message"],
                                      governmentresponse_error: retData["payroll"]["governmentResponse"]["errorMessages"].present? ? retData["payroll"]["governmentResponse"]["errorMessages"] : nil)
            puts "ENVIADO - alegra_id: #{retData["payroll"]["id"].to_s} ----- FECHA: #{Time.now} ----- NOMINA ID: #{contratospernomina.id.to_s}"
          end
          #rescue Exception => ex
          #contratospernomina.update(erros_alegra: ex.message[0..499].to_s)
          #puts "Error del proceso - #{ex.message[0..1000].to_s}"
          #end
      end
      #rescue Exception => ex
      #puts "Error del proceso Empresa no Operando - #{ex.message[0..1000].to_s}"
      #end
  end

# ********************************************************************************
# ------------------- DESCRIPCIONES DEL PROCESO ALEGRA -------------------
# # ******************************************************************************
=begin
TipoTrabajador
  01: Contributivo cotizante
  02: Contributivo beneficiario
  03: Contributivo adicional
  04: Subsidiado
  05: Sin régimen
  06: Especiales o de Excepción cotizante
  07: Especiales o de Excepción beneficiario
  08: Particular
  09: Tomador/Amparado ARL
  10: Tomador/Amparado SOAT
  11: Tomador/Amparado Planes voluntarios de salud

SubTipoTrabajador
  00: No aplica
  01: Dependiente pensionado por vejez activo

PeriodoNomina
  4: Quincenal
  5: Mensual

TipoContrato
  1: Término Fijo
  2: Término Indefinido
  3: Obra o Labor
  4: Aprendizaje
  5: Prácticas o Pasantías

Forma
  1: Contado
  2: Crédito

Metodo
  1: Instrumento no definido
  2: Crédito ACH
  3: Débito ACH
  4: Reversión débito de demanda ACH
  5: Reversión crédito de demanda ACH
  6: Crédito de demanda ACH
  7: Débito de demanda ACH
  8: Mantener
  9: Clearing Nacional o Regional
  10: Efectivo
  11: Reversión Crédito Ahorro
  12: Reversión Débito Ahorro
  13: Crédito Ahorro
  14: Débito Ahorro
  15: Bookentry Crédito
  16: Bookentry Débito
  17: Concentración de la demanda en efectivo/Desembolso Crédito (CCD)
  18: Concentración de la demanda en efectivo / Desembolso (CCD) débito
  19: Crédito Pago negocio corporativo (CTP)
  20: Cheque
  21: Proyecto bancario
  22: Proyecto bancario certificado
  23: Cheque bancario
  24: Nota cambiaria esperando aceptación
  25: Cheque certificado
  26: Cheque Local
  27: Débito Pago Negocio Corporativo (CTP)
  28: Crédito Negocio Intercambio Corporativo (CTX)
  29: Débito Negocio Intercambio Corporativo (CTX)
  30: Transferencia Crédito
  31: Transferencia Débito
  32: Concentración Efectivo / Desembolso Crédito plus (CCD+)
  33: Concentración Efectivo / Desembolso Débito plus (CCD+)
  34: Pago y depósito pre acordado (PPD)
  35: Concentración efectivo ahorros / Desembolso Crédito (CCD)
  36: Concentración efectivo ahorros / Desembolso Crédito (CCD)
  37: Pago Negocio Corporativo Ahorros Crédito (CTP)
  38: Pago Negocio Corporativo Ahorros Débito (CTP)
  39: Crédito Negocio Intercambio Corporativo (CTX)
  40: Débito Negocio Intercambio Corporativo (CTX)
  41: Concentración efectivo/Desembolso Crédito plus (CCD+)
  42: Consignación bancaria
  43: Concentración efectivo / Desembolso Débito plus (CCD+)
  44: Nota cambiaria
  45: Transferencia Crédito Bancario
  46: Transferencia Débito Interbancario
  47: Transferencia Débito Bancaria
  48: Tarjeta Crédito
  49: Tarjeta Débito
  50: Postgiro
  51: Telex estándar bancario francés
  52: Pago comercial urgente
  53: Pago Tesorería Urgente
  60: Nota promisoria
  61: Nota promisoria firmada por el acreedor
  62: Nota promisoria firmada por el acreedor, avalada por el banco
  63: Nota promisoria firmada por el acreedor, avalada por un tercero
  64: Nota promisoria firmada por el banco
  65: Nota promisoria firmada por un banco avalada por otro banco
  66: Nota promisoria firmada
  67: Nota promisoria firmada por un tercero avalada por un banco
  70: Retiro de nota por el por el acreedor
  71: Bonos
  72: Vales
  74: Retiro de nota por el por el acreedor sobre un banco
  75: Retiro de nota por el acreedor, avalada por otro banco
  76: Retiro de nota por el acreedor, sobre un banco avalada por un tercero
  77: Retiro de una nota por el acreedor sobre un tercero
  78: Retiro de una nota por el acreedor sobre un tercero avalada por un banco
  91: Nota bancaria transferible
  92: Cheque local trasferible
  93: Giro referenciado
  94: Giro urgente
  95: Giro formato abierto
  96: Método de pago solicitado no usado
  97: Clearing entre partners
  98: Cuentas de Ahorro de Tramite Simplificado (CATS)(Nequi, Daviplata, etc)
  ZZZ: Acuerdo mutuo

************************************************************
  ESTADOS DE RESPUESTA POR ALEGRA
************************************************************

Status Alegra
  REGISTERED - Indica que el documento electrónico se encuentra registrado y listo para su emisión.
  WAITING_RESPONSE - Indica que el documento electrónico se encuentra en proceso, es decir fue emitido pero se encuentra en espera de la respuesta final por parte de la DIAN.
  FAILED - Indica que la emisión del documento electrónico fue fallida.
  SENT - Indica que el documento electrónico se encuentra emitido.

Legal Status Alegra
  ACCEPTED - Indica que el documento fue validado, aceptado y autorizado por la DIAN.
  ACCEPTED_WITH_OBSERVATIONS - Indica que el documento fue validado, aceptado y autorizado por la DIAN, pero confirma un listado de advertencias en cuanto a reglas de validación.
  REJECTED - Indica que el documento fue rechazado por la DIAN. confirmando cada una de las reglas de validación que presentaron error.

************************************************************
  PARA REGISTRAR EMPRESA Y HABILITARLA ASOCIADA AL MAIN - EMPRESA PRINCIPAL
************************************************************
1. Con el servicio de crear empra
=end
end