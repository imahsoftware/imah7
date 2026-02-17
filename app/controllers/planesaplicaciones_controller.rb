class PlanesaplicacionesController < ApplicationController
  
  before_action :set_planesaplicacion, only: [:show, :edit, :update, :destroy]

  def index
    @planesaplicaciones = Planesaplicacion.all
  end

  def show
  end

  def new
    @planesaplicacion = Planesaplicacion.new
  end

  def edit
  end

  def create
    @planesaplicacion = Planesaplicacion.new(planesaplicacion_params)

    respond_to do |format|
      if @planesaplicacion.save
        flash[:notice] = 'Planesaplicacion was successfully created.'
        format.html { redirect_to(@planesaplicacion) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @planesaplicacion.update(planesaplicacion_params)
        flash[:notice] = 'Planesaplicacion was successfully updated.'
        format.html { redirect_to(@planesaplicacion) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @planesaplicacion.destroy
    respond_to do |format|
      format.html { redirect_to(planesaplicaciones_url) }
    end
  end

  private

    def set_planesaplicacion
      @planesaplicacion = Planesaplicacion.find(params[:id])
    end

    def planesaplicacion_params
      params.require(:planesaplicacion).permit!
    end
end
