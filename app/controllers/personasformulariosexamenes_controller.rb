class PersonasformulariosexamenesController < ApplicationController
  before_action :set_personasformulariosexamen, only: [:show, :destroy]

  def index
    @personasformulariosexamenes = Personasformulariosexamen.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Personasformulariosexamen.find(params[:active_id]) if params[:active_id].present?
    @personasformulario = Personasformulario.find(params[:personasformulario_id])
    @personasformulariosexamen = Personasformulariosexamen.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Personasformulariosexamen.find(params[:active_id]) if params[:active_id].present?
    @personasformulariosexamen = Personasformulariosexamen.find(params[:id])
    @personasformulario = @personasformulariosexamen.personasformulario
    respond_to { |format| format.js }
  end

  def create
    @personasformulario = Personasformulario.find(params[:personasformulario_id])
    @personasformulariosexamen = Personasformulariosexamen.new(personasformulariosexamen_params)
    @personasformulariosexamen.personasformulario_id = @personasformulario.id
    respond_to do |format|
      if @personasformulariosexamen.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @personasformulariosexamen } }
      end
    end
  end

  def update
    @personasformulariosexamen = Personasformulariosexamen.find(params[:id])
    @personasformulario = @personasformulariosexamen.personasformulario
    @personasformulariosexamen.user_act = is_admin
    respond_to do |format|
      if @personasformulariosexamen.update(personasformulariosexamen_params)
        if @personasformulariosexamen.estado.to_s == 'RECHAZADO' and @personasformulario.estado.to_s != 'RECHAZADO'
          Ejecucion.create(user_id: is_admin,
                           estado: 'PENDIENTE',
                           portafolio_id: 1,
                           tipo: 'ENVIO SMS',
                           controlador_metodo: "PersonasformulariosController.envio_retardado(#{@personasformulario.id})",
                           created_at: Time.now + 2.day)
          #mensaje = "ASEAR: Estimad@ #{@personasformulario.nombre.to_s}: Lamentamos informar que NO fuiste seleccionado para la vacante.. Tu proceso termina aca y agradecemos tu tiempo."
          #Asearsms::SendsmsServices.new.send_sms_formulario(@personasformulario.id, mensaje)
          pf = Personasformulario.find(@personasformulario.id)
          pf.estado = 'RECHAZADO'
          pf.user_estado = is_admin
          pf.fecha_estado = Time.now
          pf.save(validate: false)
          User.where(personasformulario_id: @personasformulario.id).update_all(activo: 'N')
        elsif @personasformulariosexamen.estado == 'APROBADO'
          User.where(personasformulario_id: @personasformulario.id).update_all(activo: 'S')
        end
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @personasformulariosexamen } }
      end
    end
  end

  def destroy
    @personasformulariosexamen.destroy
    respond_to do |format|
      flash['success'] = 'Eliminado correctamente'
      format.js { render inline: "location.reload();" }
    end
  end

  def notificacion
    @personasformulario = Personasformulario.find(params[:personasformulario_id])
    @personasformulariosexamen = Personasformulariosexamen.find(params[:id])
    fname = "Notificación Resultado Examen" rescue nil
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "personasformulariosexamenes/notificacion.html.erb", encoding: "UTF-8", page_size: 'Letter', :margin => { top: 10, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def notificacion_examen
    @personasformulariosexamen = Personasformulariosexamen.find(params[:id])
    mensaje = "ASEAR: Estimad@ #{@personasformulariosexamen.personasformulario.nombre.to_s rescue nil}. Tu examen medico ha sido asignado, consulta aqui mas informacion. - Url: https://appasearesp.com".html_safe
    Asearsms::SendsmsServices.new.send_sms_formulario(@personasformulariosexamen.personasformulario_id, mensaje)
    respond_to do |format|
      flash[:notice] = "El mensaje fue enviado con exito!!!"
      format.js { render inline: "location.reload();" }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_personasformulariosexamen
    @personasformulario = Personasformulario.find(params[:personasformulario_id])
    @personasformulariosexamen = Personasformulariosexamen.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def personasformulariosexamen_params
    params.require(:personasformulariosexamen).permit!
  end
end
