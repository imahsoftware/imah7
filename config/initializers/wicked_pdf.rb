# WickedPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
# https://github.com/mileszs/wicked_pdf/blob/master/README.md

# El gem wkhtmltopdf-binary 0.12.6.3 solo trae binarios x86 (amd64/i386) y no
# soporta ARM64 (p.ej. contenedores corriendo en Mac con Apple Silicon), por lo
# que el wrapper del gem ("Invalid platform... debian_11_i386") nunca va a
# encontrar un binario válido en ese caso, sin importar el valor de
# WKHTMLTOPDF_HOST_SUFFIX.
#
# El Dockerfile ya instala el paquete nativo `wkhtmltopdf` vía apt
# (arquitectura correcta para el contenedor, confirmado en /usr/bin/wkhtmltopdf).
# Lo usamos directamente por ruta absoluta: NO usar `which`, porque dentro del
# PATH de la app el wrapper del gem (.../bundle/ruby/2.7.0/bin/wkhtmltopdf)
# aparece primero y se seguiría usando el binario roto.
SYSTEM_WKHTMLTOPDF = '/usr/bin/wkhtmltopdf'.freeze

WickedPdf.config = {
  exe_path: (File.exist?(SYSTEM_WKHTMLTOPDF) ? SYSTEM_WKHTMLTOPDF : nil)
}.compact

