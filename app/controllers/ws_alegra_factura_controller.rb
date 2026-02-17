class WsAlegraFacturaController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :authenticate_user!, except: [:enviar_nomina, :prueba]

  require 'uri'
  require 'net/https'
  require 'net/http'
  require 'openssl'
  require 'open-uri'
  extend WsHelper

  # Descripcion: Crear Items de la factura electronica
  # Fecha Creacion: 20-Abril-2023
  # Autor: AFP
  def self.crear_items
    url = URI("https://api.alegra.com/api/v1/items")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(url)
    request["accept"] = "application/json"
    request["content-type"] = "application/json"
    request["authorization"] = "Basic YW5kcmVzLmNvbXB1dG9AZ21haWwuY29tOjQ4ZmY1YzIzZjEzNDhhYzViMDI2"
    request.body = JSON.dump({
                               "name": "LECHE COLANTA",
                               "description": "ESTAN ENCAJA",
                               "reference": "32662623",
                               "price": 22000,
                               "type": "product"
                             })

    response = https.request(request)
    retData = JSON.parse response.body

  end

  # Descripcion: Crear clientes de la factura electronica
  # Fecha Creacion: 20-Abril-2023
  # Autor: AFP
  def self.crear_cliente
    url = URI("https://api.alegra.com/api/v1/contacts")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(url)
    request["accept"] = "application/json"
    request["content-type"] = "application/json"
    request["authorization"] = "Basic YW5kcmVzLmNvbXB1dG9AZ21haWwuY29tOjQ4ZmY1YzIzZjEzNDhhYzViMDI2"
    request["Cookie"] = "PHPSESSID=p097du7amohqejdjp5d9pejss3"
    request.body = JSON.dump({
                               "address": {
                                 "city": "BELLO",
                                 "address": "Calle 167 sur 59"
                               },
                               "name": "CATALINA MONTOYA",
                               "identification": "828272771",
                               "mobile": "3016793066",
                               "email": "pr2jh2j2j2jh2@alegra.com",
                               "ignoreRepeated": false,
                               "phonePrimary": "2559039",
                               "type": "client"
                             })

    response = https.request(request)
    retData = JSON.parse response.body
  end

  # Descripcion: Crear factura de la factura electronica
  # Fecha Creacion: 20-Abril-2023
  # Autor: AFP
  def self.crear_factura
    url = URI("https://api.alegra.com/api/v1/invoices")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(url)
    request["accept"] = "application/json"
    request["content-type"] = "application/json"
    request["authorization"] = "Basic YW5kcmVzLmNvbXB1dG9AZ21haWwuY29tOjQ4ZmY1YzIzZjEzNDhhYzViMDI2"
    request["Cookie"] = "PHPSESSID=p097du7amohqejdjp5d9pejss3"
    request.body = JSON.dump({
                               "items": [
                                 {
                                   "tax": [
                                     {
                                       "id": 4
                                     }
                                   ],
                                   "id": 1,
                                   "name": "Arroz",
                                   "discount": 0,
                                   "observations": "Arroz para la siembra",
                                   "price": 30000,
                                   "quantity": 2
                                 },
                                 {
                                   "tax": [
                                     {
                                       "id": 4
                                     }
                                   ],
                                   "id": 2,
                                   "name": "LECHE COLANTA",
                                   "discount": 0,
                                   "observations": "LECHE COLANTA -OBSERVACION",
                                   "price": 20000,
                                   "quantity": 20
                                 }
                               ],
                               "client": {
                                 "id": 2
                               },
                               "stamp": {
                                 "newKey": "New Value"
                               },
                               "type": "NATIONAL",
                               "paymentForm": "CASH",
                               "paymentMethod": "CASH",
                               "dueDate": "2023-04-23",
                               "date": "2023-04-20",
                               "observations": "esto es una prueba de facturacion",
                               "termsConditions": "SE PAGAN DESPUES DE 15 DIAS"
                             })

    response = https.request(request)
    retData = JSON.parse response.body
  end
end