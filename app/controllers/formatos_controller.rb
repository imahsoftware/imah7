class FormatosController < ApplicationController
  before_action :set_formato, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  before_action :checkaccess

  def checkaccess
    return is_permit('formatos')
  end

  def index
    @q = Formato.ransack(params[:q])
    @formatos = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def new
    @formato = Formato.new
    render "formato_form"
  end

  def clonar
    @formato = Formato.find(params[:id])
    ActiveRecord::Base.connection.execute("CALL prc_duplicar_formato(#{@formato.id},#{is_admin})")
    respond_to do |format|
      flash[:notice] = "Formato Clonado con Exito!!!"
      format.js { render inline: "location.reload();" }
    end
  end

  def edit
    respond_to do |format|
      format.html { render :action => "formato_form" }
    end
  end

  def create
    @formato = Formato.new(formato_params)
    respond_to do |format|
      if @formato.save
        format.html { redirect_to edit_formato_path(id: @formato.id), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @formato }
      else
        format.html { render :action => "formato_form" }
        format.json { render json: @formato.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @formato.update(formato_params)
      flash['success'] = "Usuario actualizado"
      redirect_to edit_formato_path(id: @formato.id)
    else
      render "formato_form"
    end
  end

  def destroy
    @formato.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    respond_to do |format|
      format.html { redirect_to(formatos_url) }
      format.xml  { head :ok }
    end
  end

  def etapar
    if params[:etapa].to_s != ""
      User.where(id: is_admin).update_all(etapa: params[:etapa].to_s, updated_at: Time.now)
    end
    redirect_to edit_formato_path(id: params[:id].to_i)
  end

  def preliminar
    #ActiveRecord::Base.connection.execute("CALL prc_formatos(#{params[:id].to_i})")
    @formato = Formato.find(params[:id]) if params[:id]
    contratosperfecha = Contratosperfecha.find(@formato.contratosperfecha_id)
    fname = "Preliminar_" + contratosperfecha.contratospersona.identificacion.to_s rescue nil
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "formatos/preliminar", encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  private

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_admin'
    else
      "application_admin"
    end
  end

  def set_formato
    @formato = Formato.find(params[:id])
  end

  def formato_params
    params.require(:formato).permit!
  end
end
