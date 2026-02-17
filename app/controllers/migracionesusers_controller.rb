class MigracionesusersController < ApplicationController
  before_action :set_migracionesusers, only: [:show, :edit, :update, :destroy, :new, :create, :all_migracionesusers]
  before_action :all_migracionesusers, only: [:create, :update, :destroy]

  layout :determine_layout

  def index
    @user   = User.find(current_user)
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Migracionesuser.find(params[:active_id]) if params[:active_id].present?
    @user = User.find(params[:user_id])
    @migracionesuser = Migracionesuser.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Migracionesuser.find(params[:active_id]) if params[:active_id].present?
    @migracionesuser = Migracionesuser.find(params[:id])
    @user = @migracionesuser.user
    respond_to { |format| format.js }
  end

  def create
    @modulos = params[:migracionesuser][:migracion_id].reject { |c| c.empty? }
    i = 0
    for i in 0..@modulos.count-1
      @user  = User.find(params[:user_id])
      @migracionesuser = Migracionesuser.new(migracionesuser_params)
      @migracionesuser.migracion_id = @modulos[i]
      @migracionesuser.user_id = @user.id
      respond_to do |format|
        if @migracionesuser.save
          format.js
        else
          format.js { render 'layouts/errors', locals: { object: @migracionesuser } }
        end
      end
    end
  end

  def update
    @migracionesuser = Migracionesuser.find(params[:id])
    @user = @migracionesuser.user
    respond_to do |format|
      if @migracionesuser.update(migracionesuser_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @migracionesuser } }
      end
    end
  end

  def destroy
    @migracionesuser.destroy
    flash['success'] = 'Eliminado correctamente'
  end

  private

  def all_migracionesusers
    @migracionesusers = @user.migracionesusers.order("created_at asc")
  end

  def set_migracionesusers
    @user = User.find(params[:user_id])
    @migracionesuser = Migracionesuser.find(params[:id]) if params[:id]
  end

  def migracionesuser_params
    params.require(:migracionesuser).permit!
  end

  def determine_layout
    if ['index'].include?(action_name)
      #"application_menu"
      "application_admin"
    elsif ['datos'].include?(action_name)
      "without_layout"
    else
      "application_admin"
    end
  end
end
