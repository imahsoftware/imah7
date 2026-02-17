class ConceptosController < ApplicationController
  before_action :set_concepto, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess

  def checkaccess
    return is_permit('conceptos')
  end

  def index
    @q = Concepto.ransack(params[:q])
    @conceptos = @q.result.paginate(:page => params[:page], :per_page => 20).order('descripcion  asc')
    respond_to do |format|
      format.html
    end
  end

  def new
    @concepto = Concepto.new
    render "concepto_form"
  end

  def edit
    respond_to do |format|
      format.html { render :action => "concepto_form" }
    end
  end

  def create
    @concepto = Concepto.new(concepto_params)
    respond_to do |format|
      if @concepto.save
        format.html { redirect_to edit_concepto_path(id: @concepto.id), notice: "El registro ha sido creado con Exito." }
        format.json { render :show, status: :created, location: @concepto }
      else
        format.html { render :new }
        format.json { render json: @concepto.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @concepto.update(concepto_params)
      flash['success'] = "Usuario actualizado"
      redirect_to edit_concepto_path(id: @concepto.id)
    else
      render "concepto_form"
    end
  end

  def destroy
    @concepto.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    respond_to do |format|
      format.html { redirect_to(conceptos_url) }
      format.xml  { head :ok }
    end
  end

  private

  def set_concepto
    @concepto = Concepto.find(params[:id])
  end

  def concepto_params
    params.require(:concepto).permit!
  end
end
