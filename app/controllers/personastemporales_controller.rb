class PersonastemporalesController < ApplicationController
  before_action :set_personastemporal, only: [:show, :edit, :update, :destroy]

  layout :set_layout

  def new2
    @personastemporal = Personastemporal.new
    @personastemporal.contrato_id = params[:contrato_id]
  end

  def create2
    @personastemporal = Personastemporal.new(personastemporal_params)
    @personastemporal.user_id = is_admin
    respond_to do |format|
      if @personastemporal.save
        ActiveRecord::Base.connection.execute("CALL personastemp(#{@personastemporal.id})")
        flash[:notice] = "Creado con Exito."
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @personastemporal } }
      end
    end
  end

  private
  def set_layout
    if ['index', 'new', 'create', 'update'].include?(action_name)
      'blank'
    else
      'blank'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_personastemporal
    @personastemporal = Personastemporal.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def personastemporal_params
    params.require(:personastemporal).permit!
  end
end
