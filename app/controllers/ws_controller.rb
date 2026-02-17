class WsController < ApplicationController
  protect_from_forgery with: :null_session

  layout :determine_layout

  before_action :authenticate_user!, except: [:confirmacion]

  require 'uri'
  require 'net/https'
  require "json"
  require 'net/http'
  require 'openssl'
  require 'open-uri'

  extend WsHelper

  # 2025-04-28 FFA
  def self.smscolombiared(nroTel, messageSend)
    operador = Parametro.find(29).valor  
    if operador.to_s == 'COLOMBIARED'

      # Credenciales
      username = 'ASEARESP2023_OTP'
      password = 'kJfdu%e33v'
      token    = Base64.strict_encode64("#{username}:#{password}")
      # Construcción de la petición
      url     = URI.parse('https://apitellit.aldeamo.com/SmsiWS/smsSendPost/')
      headers = {
        'Authorization' => "Basic #{token}",
        'Content-Type'  => 'application/json'
      }
      payload = {
        country: "57",
        #dateToSend: nil,
        message: messageSend.to_s,
        #encoding: "UTF-8",
        messageFormat: 1,
        addresseeList: [
          {
            mobile: nroTel.to_s
          }
        ]
      }.to_json

      http    = Net::HTTP.new(url.host, url.port).tap { |h| h.use_ssl = true }
      request = Net::HTTP::Post.new(url.request_uri, headers)
      request.body = payload
      response = http.request(request)
      code     = response.code.to_i
      body     = response.body.to_s
      status   = response.is_a?(Net::HTTPSuccess) ? "Enviado" : "Error HTTP #{code}"

      begin
        response = http.request(request)
        code     = response.code.to_i
        body     = response.body.to_s
        status   = response.is_a?(Net::HTTPSuccess) ? "Enviado" : "Error HTTP #{code}"
      rescue Net::OpenTimeout, Net::ReadTimeout => e
        code   = nil
        body   = e.message
        status = "Timeout"
      rescue => e
        code   = nil
        body   = e.message
        status = "Exception: #{e.class}"
      end
      puts "response!!! #{response.to_json rescue nil}  status!!! #{status.to_s} code!!! #{code.to_s rescue nil} body!!! #{body.to_s rescue nil} "

=begin
      usuario = "api.0hhlb"
      contrasena = "kaUPJGMxNXn1iWp_l7qFGWe0g,RSAA"
      auth_token = Base64.strict_encode64("#{usuario}:#{contrasena}")

      url = URI("https://api-sms.masivapp.com/send-message")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Basic #{auth_token}" # Reemplaza con tu token de autorización real
      request.body = JSON.dump({
                                  "to" => "57#{nroTel}", # Número de teléfono dinámico
                                  "text" => "#{messageSend}"       # Mensaje dinámico
                                })
      response = https.request(request)
     puts "Enviado!!! " + request.read_body.to_s

=end

    elsif operador.to_s == 'INTICO'
      
      token = Parametro.find(28).valor  
      url = URI.parse('https://api.channelty.com/api/v1/SendTransactional')
      headers = {'Apikey' => "#{token}",'Content-Type' => 'application/json'}
      payload = {
        data: {
                name_campaign:"",
                description:"",
                prefix:"57",
                phone: nroTel.to_s,
                message: messageSend.to_s,
                variables:{
                            "nombre":"Admin",
                            "saludo":"1234"
                          },
                schedule: 0,
                datetime: "2024-10-31 09:05",
                sms_flash:1
              }
      }
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(url.request_uri, headers)
      request.body = payload.to_json
    
      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        "SMS enviado con éxito: #{response.body}"
      else
        "ERROR al enviar SMS: #{response.code} – #{response.body}"
      end
    end
  end

  def self.smsintico(nroTel, messageSend)
    token = Parametro.find(28).valor  
    url = URI.parse('https://api.channelty.com/api/v1/SendTransactional')
    headers = {'Apikey' => "#{token}",'Content-Type' => 'application/json'}
    payload = {
      data: {
              name_campaign:"",
              description:"",
              prefix:"57",
              phone: nroTel.to_s,
              message: messageSend.to_s,
              variables:{
                          "nombre":"Admin",
                          "saludo":"1234"
                        },
              schedule: 0,
              datetime: "2024-10-31 09:05",
              sms_flash:1
            }
    }
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url.request_uri, headers)
    request.body = payload.to_json
  
    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      "SMS enviado con éxito: #{response.body}"
    else
      "ERROR al enviar SMS: #{response.code} – #{response.body}"
    end
  end

  # ********************************************************************************
  # ------------------- INICIA PROCESO DE SIIGO ------------------------------------
  # # ******************************************************************************
  def self.tokensiigo(idPortafolio)
=begin
    portafolio = Portafolio.find(idPortafolio)
    #url = URI("https://siigonube.siigo.com:50050/connect/token")
    url = URI("https://integrations.siigo.com/auth/connect/token")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request.body = "grant_type=password&username=ASEARSeeab44e7%40apionmicrosoft.com&password=3oq%250097%24E&scope=WebApi%20offline_access"
    #request.body = "grant_type=password&username=#{portafolio.siigo_username.to_s}&password=#{portafolio.siigo_password.to_s}&scope=WebApi%20offline_access&="
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request["Accept"] = "application/json"
    #request["Authorization"] = "Basic #{portafolio.siigo_basic.to_s}"
    request["Authorization"] = "Basic U2lpZ29XZWI6QUJBMDhCNkEtQjU2Qy00MEE1LTkwQ0YtN0MxRTU0ODkxQjYx"
    response = https.request(request)
    retData = JSON.parse response.body
    token = retData["access_token"]
    puts token
    return token
=end

    portafolio = Portafolio.find(idPortafolio)
    url = URI("https://api.siigo.com/auth")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(url)
    request.body = JSON.dump({ "username": "nelcy.bedoya@asearesp.com", "access_key": "MGMwZWZjNDQtNTVjNi00ZjE4LWIwZGMtYmQwNTdiZmU1NmI1OmtqNFBDLWgjME0=" })
    request["Content-Type"] = "application/json"
    response = https.request(request)
    retData = JSON.parse response.body
    token = retData["access_token"]
    return token
  end

  def self.crear_account(idP)
    #Account Create Complete
    p = Contrato.find(idP)
    e = Empresa.find(p.empresa_id)
    t = Tiposdocumento.find(e.tiposdocumento_id)
    po = Portafolio.find(1)
    token = self.tokensiigo(po.id)
    if p.direccion.to_s == ""
      dir = "Sin info"
    else
      dir = p.direccion.to_s
    end
    if token
      url = URI("https://api.siigo.com/v1/customers")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["Authorization"] = token
      request["Partner-Id"] = 'AsearApp'
      request.body = JSON.generate({ "type": "Customer",
                                     "person_type": "#{self.vlr_person_type(t.descripcion)}",
                                     "id_type": "#{self.vlr_idtypecode(t.descripcion)}",
                                     "identification": "#{e.identificacion.to_s}",
                                     "check_digit": "4",
                                     "name": self.vlr_name_array(t.descripcion, e.nombre),
                                     "commercial_name": "Siigo",
                                     "branch_office": 0,
                                     "active": true,
                                     "vat_responsible": false,
                                     "fiscal_responsibilities": [{ "code": "R-99-PN" }],
                                     "address": { "address": "#{dir}",
                                                  "city": { "country_code": "Co",
                                                            "state_code": "#{Municipio.find(p.municipio_id).coddian_departamento}",
                                                            "city_code": "#{Municipio.find(p.municipio_id).codigo}" },
                                                  "postal_code": "110911" },
                                     "phones": [{ "indicative": "57",
                                                  "number": "#{p.telefono_empresa.to_s}",
                                                  "extension": "0" }],
                                     "contacts": [{ "first_name": "#{e.nombre}",
                                                    "last_name": "#{e.nombre}", "email": "#{p.contacto_email.to_s}",
                                                    "phone": { "indicative": "57",
                                                               "number": "#{p.telefono_empresa.to_s}",
                                                               "extension": "0" } }],
                                     "comments": "Registro Siigo" })
      response = https.request(request)
      retData = JSON.parse response.body
      if retData["id"].present?
        ActiveRecord::Base.connection.execute("update contratos set siigo_account = '#{retData["id"].to_s}', response_siigo = '#{response.body.to_s}', error_siigo = null where id = #{idP}")
      else
        ActiveRecord::Base.connection.execute("update contratos set error_siigo = '#{retData["Errors"][0]["Message"].gsub("'","").to_s}', response_siigo = '#{response.body.to_s}' where id = #{idP}")
      end
      #self.crear_contact(idP, dato)
    end
  rescue Exception => e
    ActiveRecord::Base.connection.execute("update contratos set error_siigo = '#{e.message[0..500].gsub("'","").to_s}' where id = #{idP}")
    puts "********* Error(self.crear_account) .............................. ******** " + e.message[0..500].to_s

=begin
    p = Contrato.find(idP)
    e = Empresa.find(p.empresa_id)
    t = Tiposdocumento.find(e.tiposdocumento_id)
    po = Portafolio.find(1)
    token = self.tokensiigo(po.id)
    if p.direccion.to_s == ""
      dir = "Sin info"
    else
      dir = p.direccion.to_s
    end
    if token
      #url = URI("http://siigoapi.azure-api.net/siigo/api/v1/Accounts/Create?namespace=v1")
      url = URI("https://integrations.siigo.com/api/v1/Accounts/Create?namespace=v1")
      http = Net::HTTP.new(url.host, url.port);
      http.use_ssl = true
      request = Net::HTTP::Post.new(url)
      #request["Ocp-Apim-Subscription-Key"] = "#{po.siigo_ocp.to_s}"
      request["Ocp-Apim-Subscription-Key"] = "82303da092c34fa0859d7214136f4694"
      request["Authorization"] = token
      request["Content-Type"] = "application/json"
      request.body = "{\"Id\": 0,
                            \"IsLeaflet\": false,
                            \"IsCustomer\": true,
                            \"IsSupplier\": false,
                            \"IsDealer\": false,
                            \"IsBank\": false,
                            \"IsSocialReason\": #{self.vlr_issocialreason(t.descripcion)},
                            \"FullName\": \"#{self.vlr_fullname(t.descripcion, e.nombre)}\",
                            \"FirstName\": \"#{self.vlr_name(t.descripcion, e.nombre)}\",
                            \"LastName\": \"#{self.vlr_name(t.descripcion, e.nombre)}\",
                            \"IdTypeCode\": \"#{self.vlr_idtypecode(t.descripcion)}\",
                            \"Identification\": \"#{e.identificacion.to_s}\",
                            \"CheckDigit\": null,
                            \"BranchOffice\": 0,
                            \"IsVATCompanyType\": false,
                            \"WebSite\": null,
                            \"Address\": \"#{dir}\",
                            \"PostalCode\": null,
                            \"Phone\": {
                              \"Indicative\": 57, \"Number\": #{p.telefono_empresa.to_s}, \"Extention\": 0
                            },
                            \"City\": {
                              \"CountryCode\": \"Co\",
                              \"StateCode\": \"0#{Municipio.find(p.municipio_id).coddian_departamento}\",
                              \"CityCode\": \"#{Municipio.find(p.municipio_id).codigo}\"
                            },
                            \"EMail\": \"#{p.contacto_email.to_s}\",
                            \"IsActive\": true, \"DirectorID\": 0,\"SalesmanID\": 0,\"CollectorID\": 0,\"PrincipalContactID\": 0,
                            \"FiscalResponsibilities\": [\"R-99-PN\"]}"
      response = http.request(request)
      #puts "valores json......." + request.body.to_s
      #puts response.read_body
      retData = JSON.parse response.body
      dato = retData["Id"]
      puts "------------------- Create Account ------------------- " + dato.to_s
      self.crear_contact(idP,dato)
    end
  rescue Exception => e
    puts "Error(self.crear_account) ..."+e.message[0..500].to_s
=end
  end

=begin

  def self.crear_contact(idP, idA)
    #Contact Create Complete
    p = Contrato.find(idP)
    po = Portafolio.find(1)
    token = self.tokensiigo(po.id)
    if p.direccion.to_s == ""
      dir = "Sin info"
    else
      dir = p.direccion.to_s
    end
    if token
      url = URI("https://integrations.siigo.com/api/v1/Contacts/Create?namespace=v1")
      http = Net::HTTP.new(url.host, url.port);
      http.use_ssl = true
      request = Net::HTTP::Post.new(url)
      #request["Ocp-Apim-Subscription-Key"] = "#{po.siigo_ocp.to_s}"
      request["Ocp-Apim-Subscription-Key"] = "82303da092c34fa0859d7214136f4694"
      # request["Ocp-Apim-Subscription-Key"] = "9677900291584b759e94c1bd61f38ef3"
      request["Authorization"] = token
      request["Content-Type"] = "application/json"
      request.body = "{\r\"Id\": 0,\r
      \"Code\": null,\r
      \"AccountID\": #{idA},    \r
      \"Phone1\": {\r
      \"Indicative\": null,\r
      \"Number\": 0343214444,\r
      \"Extention\": null\r
                                    },\r
      \"Mobile\": {\r
      \"Indicative\": null,\r
      \"Number\": 0343214444,\r
      \"Extention\": null\r
                                    },\r
      \"EMail\": \"#{p.contacto_email.to_s}\",\r
      \"FirstName\": \"#{p.contacto_nombre.to_s}\",\r
      \"LastName\": \"#{p.contacto_apellido.to_s}\",\r
      \"Fax\": null,\r
      \"IsPrincipal\": true,\r
      \"Gender\": null,\r
      \"ChargeID\": null,\r
      \"BirthDate\": null\r\n}"
      response = http.request(request)
      #puts "valores json......." + request.body.to_s
      #puts response.read_body
      retData = JSON.parse response.body
      dato = retData["Id"]
      ActiveRecord::Base.connection.execute("update contratos set siigo_account = #{idA}, siigo_contact = #{dato} where id = #{idP}")
      puts "-------------------- Create Contact ----------------------------" + dato.to_s
    end
  rescue Exception => e
    puts "********* Error(self.crear_contact) .............................. ******** " + e.message[0..500].to_s
  end
=end

  def self.crear_detalle(idC)
    p = Contratosprefdetalle.find(idC)
    po = Portafolio.find(1)
    token = self.tokensiigo(po.id)
    if token
      url = URI("https://api.siigo.com/v1/products")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["Authorization"] = token
      request["Partner-Id"] = 'AsearApp'
      request.body = JSON.dump({ "code": "ASEAR-#{p.id.to_s}", "name": "#{p.detalle[0..99].to_s}", "account_group": p.tipoprodkey.to_s})

=begin
      url = URI("https://integrations.siigo.com/api/v1/Products/Create?namespace=v1")
      http = Net::HTTP.new(url.host, url.port);
      http.use_ssl = true
      request = Net::HTTP::Post.new(url)
      #request["Ocp-Apim-Subscription-Key"] = "#{po.siigo_ocp.to_s}"
      request["Ocp-Apim-Subscription-Key"] = "82303da092c34fa0859d7214136f4694"
      request["Authorization"] = token
      request["Content-Type"] = "application/json"
      request.body = "{\r\"Code\": \"ASEAR-#{p.id.to_s}\",
                          \"Description\": \"#{p.detalle.to_s}\",
                          \"ProductTypeKey\": \"#{p.tipoprodkey.to_s}\",
                          \"AccountGroupID\":  455,\n
      \"MeasurementUnitCode\": 94\n}"
      response = http.request(request)
      #puts response.read_body
      puts "-------------------- Create detalle ----------------------------" + p.id.to_s
=end
      response = https.request(request)
      retData = JSON.parse response.body
      if retData["id"].present?
        ActiveRecord::Base.connection.execute("update contratosprefdetalles set siigo_products = '#{retData["id"].to_s}', response_siigo = '#{response.body.to_s}', error_siigo = null where id = #{idC}")
      else
        ActiveRecord::Base.connection.execute("update contratosprefdetalles set error_siigo = '#{retData["Errors"][0]["Message"].gsub("'","").to_s}', response_siigo = '#{response.body.to_s}' where id = #{idC}")
      end
    end
  rescue Exception => e
    puts "********* Error(self.crear_concepto) .............................. ******** " + e.message[0..500].to_s
  end

  def self.crear_factura(idF)
    # INICIA
    p = Contratosprefactura.find(idF)
    #puts "---------- Create Contact desde factura ------------"
    self.crear_account(p.contrato_id) # Aqui crea cuenta y contacto.
    #puts "---------- Final Contact desde factura ------------"
    po = Portafolio.find(1)
    pe = Contrato.find(p.contrato_id)
    e = Empresa.find(pe.empresa_id)
    t = Tiposdocumento.find(e.tiposdocumento_id)
    token = self.tokensiigo(po.id)
    if token
      url = URI("https://api.siigo.com/v1/invoices")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["Authorization"] = token
      request["Partner-Id"] = 'AsearApp'
      vlr = []
      puts "---------- Ingreso ------------"
      i = 0
      cant = p.contratosprefdetalles.count rescue nil
      p.contratosprefdetalles.each do |d|
        i = i + 1
        detalle = ""
        if i == cant
          detalle = d.detalle.to_s + " - ORDEN DE COMPRA NRO. #{p.contrato.nro_contrato.to_s rescue nil} - OBJETO: #{p.contrato.objeto.to_s rescue nil} - PERIODO FACTURADO: #{p.periodo.to_s rescue nil}"
        else
          detalle = d.detalle.to_s rescue nil
        end
        self.crear_detalle(d.id)
        if d.vlr_TaxAddId.to_s != '-1'
          detalle2 = {
            "code" => "#{d.tipo_producto.to_s rescue nil}",
            "description" => "#{detalle.to_s rescue nil}",
            "quantity" => d.cantidad.to_f,
            "taxes" => [
              {
                "id" => d.vlr_TaxAddId
              }
            ],
            "price" => d.valor_unitario.to_f
          }
        else
          detalle2 = {
            "code" => "#{d.tipo_producto.to_s rescue nil}",
            "description" => "#{detalle.to_s rescue nil}",
            "quantity" => d.cantidad.to_f,
            "price" => d.valor_unitario.to_f
          }
        end
        vlr << detalle2
      end



      # Para PaymentMeansCode - se debe de colocar el tipo de facturacion (Si es Efectivo id: 1405, Pago a crédito id: 1406 )
      vlrab = []
      detalle3 = {
        "id" => "1406",
        "value" => "#{p.contratosprefdetalles.sum("siigo_total").to_f}",
        "due_date" => "#{p.fecha_vencimiento.strftime("%Y-%m-%d").to_s rescue nil}"
      }
      vlrab << detalle3

      request.body = JSON.dump({
                                 "document": {
                                   "id": po.siigo_doccode.to_s # 24446 Es de pruebas , se debe de consumir el servicio de tipo de comprobante
                                 },
                                 "date": "#{Time.now.strftime("%Y-%m-%d").to_s}",
                                 "customer": {
                                   "identification": "#{e.identificacion.to_s}",
                                   "branch_office": "0"
                                 },
                                 "seller": 749, # 749: API - 158: NELCY BEDOYA
                                 "items": vlr,
=begin
                                 "stamp": {
                                   "send": true
                                 },
                                 "mail": {
                                   "send": true
                                 },
=end
                                 "observations": "#{p.observacion}",
                                 "payments": vlrab
                               })
      response = https.request(request)
      retData = JSON.parse response.body
      if retData["id"].present?
        ActiveRecord::Base.connection.execute("update contratosprefacturas set siigo_response = '#{response.body[0..3999]}', siigo_request = '#{request.body.to_s[0..7999]}', siigo_id = '#{retData["id"]}', siigo_nro = '#{retData["number"]}', siigo_fecha = now() where id = #{idF}")
      else
        ActiveRecord::Base.connection.execute("update contratosprefacturas set siigo_response = '#{response.body[0..3999]}', siigo_request = '#{request.body[0..7999]}' where id = #{idF}")
      end

      puts "-------------------- Create Factura ----------------------" + retData["number"].to_s
    end
    # TERMINA

=begin
    p = Contratosprefactura.find(idF)
    #puts "---------- Create Contact desde factura ------------"
    self.crear_account(p.contrato_id) # Aqui crea cuenta y contacto.
    #puts "---------- Final Contact desde factura ------------"
    po = Portafolio.find(1)
    pe = Contrato.find(p.contrato_id)
    e = Empresa.find(pe.empresa_id)
    t = Tiposdocumento.find(e.tiposdocumento_id)
    token = self.tokensiigo(po.id)
    if token
      url = URI("https://integrations.siigo.com/api/v1/Invoice/Save?namespace=v1")
      http = Net::HTTP.new(url.host, url.port);
      http.use_ssl = true
      request = Net::HTTP::Post.new(url)
      #request["Ocp-Apim-Subscription-Key"] = "#{po.siigo_ocp.to_s}"
      request["Ocp-Apim-Subscription-Key"] = "82303da092c34fa0859d7214136f4694"
      request["Authorization"] = token
      request["Content-Type"] = "application/json"
      vlr = []
      puts "---------- Ingreso ------------"
      i = 0
      cant = p.contratosprefdetalles.count rescue nil
      p.contratosprefdetalles.each do |d|
        i = i + 1
        detalle = ""
        if i == cant
          detalle = d.detalle.to_s + " - ORDEN DE COMPRA NRO. #{p.contrato.nro_contrato.to_s rescue nil} - OBJETO: #{p.contrato.objeto.to_s rescue nil} - PERIODO FACTURADO: #{p.periodo.to_s rescue nil}"
        else
          detalle = d.detalle.to_s rescue nil
        end
        self.crear_detalle(d.id)
        vlr << " {\"ProductCode\": \"#{d.tipo_producto.to_s rescue nil}\",
                  \"Description\": \"#{detalle rescue nil}\",
                  \"GrossValue\": #{d.vlr_GrossValue.to_f},
                  \"BaseValue\": #{d.vlr_BaseValue.to_f},
                  \"Quantity\": #{d.cantidad.to_f},
                  \"UnitValue\": #{d.valor_unitario.to_f},
                  \"TaxAddName\": '#{d.vlr_TaxAddName.to_s}',
                  \"TaxAddId\": #{d.vlr_TaxAddId},
                  \"TaxAddValue\": #{d.valor_iva.to_f},
                  \"TaxAddPercentage\": #{d.vlr_TaxAddPercentage},
                  \"TaxDiscountName\": '',
                  \"TaxDiscountId\": -1,
                  \"TaxDiscountValue\": 0,
                  \"TaxDiscountPercentage\": 0,
                  \"DiscountValue\": 0,
                  \"DiscountPercentage\": #{d.porc_desc.to_f},
                  \"TotalValue\": #{d.vlr_TotalValue.to_f},
                  \"TaxAdd2Name\": '',
                  \"TaxAdd2Id\": -1,
                  \"TaxAdd2Value\": 0,
                  \"TaxAdd2Percentage\": 0}"
        #puts vlr
      end
      vlrab = []
      # Para PaymentMeansCode - se debe de colocar el tipo de facturacion (Si es Efectivo id: 1405, Pago a crédito id: 1406 )
      vlrab << " { \"PaymentMeansCode\": 1406,
                   \"Value\": #{p.contratosprefdetalles.sum("siigo_total").to_f},
                   \"DueDate\": \"#{p.fecha_vencimiento.strftime("%Y%m%d").to_s}\",
                   \"DueQuote\": 1}"

      request.body = "{\"Header\": {
                                    \"DocCode\": #{po.siigo_doccode.to_s},
                                    \"Number\": 0,
                                    \"DocDate\": \"#{Time.now.strftime("%Y%m%d").to_s}\",
                                    \"VATTotalValue\": #{p.contratosprefdetalles.sum("valor_iva").to_f},
                                    \"RetVATTotalID\": -1,
                                    \"RetVATTotalPercentage\": -1,
                                    \"RetVATTotalValue\": 0,
                                    \"RetICATotalID\": -1,
                                    \"RetICATotalValue\": 0,
                                    \"RetICATotaPercentage\": -1,
                                    \"SelfWithholdingTaxID\": -1,
                                    \"TotalValue\": #{p.contratosprefdetalles.sum("siigo_total").to_f},
                                    \"TotalBase\": #{p.contratosprefdetalles.sum("siigo_subtotal").to_f},
                                    \"SalesmanIdentification\": \"#{po.siigo_salesmansdentification.to_s}\",
                                    \"Observations\": \"#{p.observacion}\",
                                    \"Account\": {
                                        \"IsSocialReason\": #{self.vlr_issocialreason(t.descripcion)},
                                        \"FullName\": \"#{self.vlr_fullname(t.descripcion, e.nombre)}\",
                                        \"FirstName\": \"#{self.vlr_name(t.descripcion, e.nombre)}\",
                                        \"LastName\": \"#{self.vlr_name(t.descripcion, e.nombre)}\",
                                        \"IdTypeCode\": \"#{self.vlr_idtypecode(t.descripcion)}\",
                                        \"Identification\": \"#{e.identificacion.to_s}\",
                                        \"CheckDigit\": 8,
                                        \"BranchOffice\": 0,
                                        \"IsVATCompanyType\": false,
                                        \"City\": {
                                            \"CountryCode\": \"Co\",
                                            \"StateCode\": \"#{Municipio.find(pe.municipio_id).coddian_departamento}\",
                                            \"CityCode\": \"#{Municipio.find(pe.municipio_id).codigo}\"
                                        },
                                        \"Address\": \"Dirección Tercero\",
                                        \"Phone\": {
                                            \"Number\": #{pe.telefono_empresa.to_s}
                                        }
                                  },
                            \"Contact\": {
                                \"Phone1\": {
                                    \"Number\": #{pe.telefono_empresa.to_s}
                                },
                                \"Mobile\": {
                                    \"Number\": 0
                                },
                                \"EMail\": \"#{pe.contacto_email.to_s}\",
                                \"FirstName\": \"#{self.vlr_name(t.descripcion, pe.contacto_nombre)}\",
                                \"LastName\": \"#{self.vlr_name(t.descripcion, pe.contacto_apellido)}\",
                                \"IsPrincipal\": true,
                            },
                        },
                      \"Items\": [#{vlr.join(',')}],
                      \"Payments\": [#{vlrab.join(',')}]\n}"
      response = http.request(request)
      #puts request.body.to_s
      #puts response.body
      # --puts "valores json......." + request.body.to_s
      # --puts response.read_body
      retData = JSON.parse response.body
      #puts retData
      ActiveRecord::Base.connection.execute("update contratosprefacturas set siigo_id = #{retData["Header"]["Id"]}, siigo_nro = #{retData["Header"]["Number"]}, siigo_fecha = now(), siigo_observacion = null where id = #{idF}")
      puts "-------------------- Create Factura ----------------------" + retData["Header"]["Number"].to_s
      #puts retData
    end
=end
  end

  private

  def determine_layout
    if ['respuesta', 'confirmacion'].include?(action_name)
      "login"
    else
      "application_admin"
    end
  end
end