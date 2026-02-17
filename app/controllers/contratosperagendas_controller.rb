class ContratosperagendasController < ApplicationController
  before_action :set_contratosperagenda, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  #before_action :checkaccess

  def new
    if Contratosperagenda.exists?(contratospersona_id: params[:contratospersona_id]) == true
      @contratosperagenda = Contratosperagenda.where(contratospersona_id: params[:contratospersona_id]).first
      respond_to do |format|
        format.html { redirect_to edit_contratosperagenda_path(id: @contratosperagenda.id) }
      end
    else
      @contratosperagenda = Contratosperagenda.new
      @contratosperagenda.contratospersona_id = params[:contratospersona_id]
      render "contratosperagenda_form"
    end
  end

  def edit
    respond_to do |format|
      format.html { render :action => "contratosperagenda_form" }
    end
  end

  def create
    @contratosperagenda = Contratosperagenda.new(contratosperagenda_params)
    @contratosperagenda.user_id = is_admin
    respond_to do |format|
      if @contratosperagenda.save
        ActiveRecord::Base.connection.execute("update contratospersonas set contrato_fecha = '#{@contratosperagenda.fecha.to_date}',
                                                                            contrato_hora = '#{@contratosperagenda.hora}' where id = #{@contratosperagenda.contratospersona_id}")
        format.html { redirect_to edit_contratosperagenda_path(id: @contratosperagenda.id), notice: "Agenda registrada con exito." }
        format.json { render :show, status: :created, location: @contratosperagenda }
      else
        format.html { render :action => "contratosperagenda_form" }
        format.json { render json: @contratosperagenda.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @contratosperagenda.update(contratosperagenda_params)
      ActiveRecord::Base.connection.execute("update contratospersonas set contrato_fecha = '#{@contratosperagenda.fecha.to_date}',
                                                                          contrato_hora = '#{@contratosperagenda.hora}' where id = #{@contratosperagenda.contratospersona_id}")
      flash[:notice] = "Actualizado con Exito"
      redirect_to edit_contratosperagenda_path(id: @contratosperagenda.id, etapa: 'A')
    else
      render "contratosperagenda_form"
    end
  end

  private

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_contratosperagendas'
    elsif ['validacion'].include?(action_name)
      "inscripcion_layout"
    else
      "application_admin"
    end
  end

  def set_contratosperagenda
    @contratosperagenda = Contratosperagenda.find(params[:id])
  end

  def contratosperagenda_params
    params.require(:contratosperagenda).permit!
  end
end

