class DocumentosfirmasController < ApplicationController

  layout :set_layout

  def new
    @documentosfirma = Documentosfirma.new
  end

  def abrirfirma
  end

  def firma
    @documentosfirma = Documentosfirma.new
    @documentosfirma.portafolio_id = is_portafolio
    @documentosfirma.user_id = is_admin
    @documentosfirma.tabla = params[:documentosfirma][:tabla]
    @documentosfirma.referencia_id = params[:documentosfirma][:referencia_id]
    @documentosfirma.firma = params[:documentosfirma][:firma]
    arraypp = params[:documentosfirma][:firma].split(',')
    imagefile = Base64.decode64(arraypp[1])
    if @documentosfirma.save
      @documentosfirma.update(signature: "firma_digital_#{@documentosfirma.id}.png")
      File.open("#{::Rails.root}/app/assets/images/documentosfirmas/#{@documentosfirma.signature}", 'wb') { |f| f.write(imagefile) }
      filesave = File.open(Rails.root.join('app/assets/images/documentosfirmas/', 'firma_digital_' + @documentosfirma.id.to_s + '.png'), 'rb')
      @documentosfirma.update(documentofirma: filesave)
      File.delete(Rails.root.join('app/assets/images/documentosfirmas/', 'firma_digital_' + @documentosfirma.id.to_s + '.png')) if File.exists? Rails.root.join('app/assets/images/documentosfirmas/', 'firma_digital_' + @documentosfirma.id.to_s + '.png')
    end
    eval("redirect_to #{params[:documentosfirma][:ruta]}")
  end

  private

  def set_layout
    if ['new'].include?(action_name)
      'firma'
    end
  end

  def documentosfirma_params
    params.require(:documentosfirma).permit!
  end
end