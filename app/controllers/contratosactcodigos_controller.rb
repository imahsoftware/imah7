class ContratosactcodigosController < ApplicationController
  before_action :set_contratosactcodigo, only: [:show, :edit, :update, :destroy]

  def new
    @contratosactcodigo = Contratosactcodigo.new
    @contratosactcodigo.user_id = params[:user_id]
  end

  def create
    @contratosactcodigo = Contratosactcodigo.new(contratosactcodigo_params)
    @contratosactcodigo.user_id = params[:user_id]
    respond_to do |format|
      if @contratosactcodigo.save
        flash[:notice] = "Codigo Registrado con exito."
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosactcodigo } }
      end
    end
  end

  def evaluar
    contratossede_id = params[:contratossede_id]
    nodo = params[:nodo]
    isadmin = is_admin
    if Contratosactcodigo.where(["contratossede_id = #{contratossede_id} and nodo = '#{nodo}' and user_id = #{isadmin} and date(created_at) = curdate()"]).exists? == false
      ActiveRecord::Base.connection.execute("
         insert into contratosactcodigos (contratossede_id,user_id,tiposevaluacion_id,nodo,created_at,updated_at)
         select  #{contratossede_id},#{isadmin},id,tipo,now(),now()
         from    tiposevaluaciones
         where   tipo = '#{nodo}'
         order by id asc")
      ActiveRecord::Base.connection.execute("CALL prc_verifica_revision(#{isadmin})")
    end
    redirect_to edit_individual_contratosactcodigos_path(contratossede_id: contratossede_id, user_id: isadmin, nodo: nodo)
  end

  def edit_individual
    contratossede_id = params[:contratossede_id]
    user_id = params[:user_id]
    nodo = params[:nodo]
    @contratosactcodigos = Contratosactcodigo.where(["contratossede_id = #{contratossede_id} and nodo = '#{nodo}' and user_id = #{user_id} and date(created_at) = curdate()"]).order("id asc")
  end

  def update_individual
    contratossede_id = ""
    user_id = ""
    nodo = ""
    JSON.parse(params[:contratosactcodigos].to_json).each do |object|
      contratossede_id = Contratosactcodigo.find(object[0]).contratossede_id.to_s
      user_id = Contratosactcodigo.find(object[0]).user_id.to_s
      nodo = Contratosactcodigo.find(object[0]).nodo.to_s
      break if user_id != ""
    end
    Contratosactcodigo.update(params[:contratosactcodigos].keys, params[:contratosactcodigos].values)
    flash[:notice] = "Actualizada con Exito."
    ActiveRecord::Base.connection.execute("CALL prc_contratosactcodigos(#{contratossede_id},'#{nodo}',#{user_id},0,'01')") #Informe... FFA 20210422
    ActiveRecord::Base.connection.execute("CALL prc_verifica_revision(#{user_id})")
    redirect_to edit_individual_contratosactcodigos_path(contratossede_id: contratossede_id, user_id: user_id, nodo: nodo)
  end


  # GET /contratosactcodigos
  # GET /contratosactcodigos.json
  def index
    @contratosactcodigos = Contratosactcodigo.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contratosactcodigo
      @contratosactcodigo = Contratosactcodigo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contratosactcodigo_params
      params.require(:contratosactcodigo).permit!
    end
end
