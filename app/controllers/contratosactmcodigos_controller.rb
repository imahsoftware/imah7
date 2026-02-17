class ContratosactmcodigosController < ApplicationController
  before_action :set_contratosactmcodigo, only: [:show, :edit, :update, :destroy]

  def new
    @contratosactmcodigo = Contratosactmcodigo.new
    @contratosactmcodigo.user_id = params[:user_id]
  end

  def create
    @contratosactmcodigo = Contratosactmcodigo.new(contratosactmcodigo_params)
    @contratosactmcodigo.user_id = params[:user_id]
    respond_to do |format|
      if @contratosactmcodigo.save
        flash[:notice] = "Codigo Registrado con exito."
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosactmcodigo } }
      end
    end
  end

  def evaluar
    contratossede_id = params[:contratossede_id]
    nodo = params[:nodo]
    isadmin = is_admin
    if Contratosactmcodigo.where(["contratossede_id = #{contratossede_id} and nodo = '#{nodo}' and user_id = #{isadmin} and date(created_at) = curdate()"]).exists? == false
      ActiveRecord::Base.connection.execute("
         insert into contratosactmcodigos (contratossede_id,user_id,tiposmevaluacion_id,nodo,created_at,updated_at)
         select  #{contratossede_id},#{isadmin},id,tipo,now(),now()
         from    tiposmevaluaciones
         where   tipo = '#{nodo}'
         order by id asc")
      ActiveRecord::Base.connection.execute("CALL prc_verifica_revision(#{isadmin})")
    end
    redirect_to edit_individual_contratosactmcodigos_path(contratossede_id: contratossede_id, user_id: isadmin, nodo: nodo)
  end

  def edit_individual
    contratossede_id = params[:contratossede_id]
    user_id = params[:user_id]
    nodo = params[:nodo]
    @contratosactmcodigos = Contratosactmcodigo.where(["contratossede_id = #{contratossede_id} and nodo = '#{nodo}' and user_id = #{user_id} and date(created_at) = curdate()"]).order("id asc")
  end

  def update_individual
    contratossede_id = ""
    user_id = ""
    nodo = ""
    JSON.parse(params[:contratosactmcodigos].to_json).each do |object|
      contratossede_id = Contratosactmcodigo.find(object[0]).contratossede_id.to_s
      user_id = Contratosactmcodigo.find(object[0]).user_id.to_s
      nodo = Contratosactmcodigo.find(object[0]).nodo.to_s
      break if user_id != ""
    end
    Contratosactmcodigo.update(params[:contratosactmcodigos].keys, params[:contratosactmcodigos].values)
    flash[:notice] = "Actualizada con Exito."
    ActiveRecord::Base.connection.execute("CALL prc_contratosactcodigos(#{contratossede_id},'#{nodo}',#{user_id},0,'02')") #Informe... FFA 20210422
    ActiveRecord::Base.connection.execute("CALL prc_verifica_revision(#{user_id})")
    redirect_to edit_individual_contratosactmcodigos_path(contratossede_id: contratossede_id, user_id: user_id, nodo: nodo)
  end


  # GET /contratosactmcodigos
  # GET /contratosactmcodigos.json
  def index
    @contratosactmcodigos = Contratosactmcodigo.all
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosactmcodigo
    @contratosactmcodigo = Contratosactmcodigo.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contratosactmcodigo_params
    params.require(:contratosactmcodigo).permit!
  end
end
