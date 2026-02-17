class ContratospernovedadesController < ApplicationController
  before_action :set_contratospernovedad, only: [:show, :destroy, :new]

  def index
    @contratospernovedades = Contratospernovedad.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratospernovedad.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratospernovedad = Contratospernovedad.new
    if Contratosperfecha.where(contratospersona_id: @contratospersona.id, contrato_id: 24).exists?
      ddias = Parametro.find(1).valor.to_i
    else
      ddias = 0
    end
    @fechas = Objeto.find_by_sql("SELECT CONVERT((@rownum:=@rownum+1),CHAR) pos, f.fecha, DATE_FORMAT(f.fecha,'%b-%d') formatdate
                                  FROM  (SELECT @rownum:=0) r, fechas f
                                  WHERE  f.fecha  >= (SELECT (CASE WHEN DATE_FORMAT(MIN(inicio),'%m') = DATE_FORMAT(curdate(),'%m') THEN DATE_ADD(MIN(inicio),INTERVAL -#{ddias} DAY) ELSE MIN(inicio) END)
                                                      FROM   periodosliquidaciones p
                                                      WHERE  p.termino = '#{@contratospersona.datogrupotermino.to_s}' AND p.estado = 'P'
                                                      and    p.id not in (select distinct periodosliquidacion_id from contratospernominas where contratosperfecha_id = #{@contratospersona.idperfecha}))
                                  AND    f.fecha <= (SELECT MAX(fin)
                                                      FROM   periodosliquidaciones p
                                                      WHERE  p.termino = '#{@contratospersona.datogrupotermino.to_s}' AND p.estado = 'P'
                                                      AND    CURDATE() BETWEEN p.inicio AND (CASE WHEN DATE_FORMAT(p.fin,'%d') = '15' THEN p.fin ELSE LAST_DAY(p.fin) END))")
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratospernovedad.find(params[:active_id]) if params[:active_id].present?
    @contratospernovedad = Contratospernovedad.find(params[:id])
    @contratospersona = @contratospernovedad.contratospersona
    if Contratosperfecha.where(contratospersona_id: @contratospersona.id, contrato_id: 24).exists?
      ddias = Parametro.find(1).valor.to_i
    else
      ddias = 0
    end
    @fechas = Objeto.find_by_sql("SELECT CONVERT((@rownum:=@rownum+1),CHAR) pos, f.fecha, DATE_FORMAT(f.fecha,'%b-%d') formatdate
                                  FROM  (SELECT @rownum:=0) r, fechas f
                                  WHERE  f.fecha  >= (SELECT (CASE WHEN DATE_FORMAT(MIN(inicio),'%m') = DATE_FORMAT(curdate(),'%m') THEN DATE_ADD(MIN(inicio),INTERVAL -#{ddias} DAY) ELSE MIN(inicio) END)
                                                      FROM   periodosliquidaciones p
                                                      WHERE  p.termino = '#{@contratospersona.datogrupotermino.to_s}' AND p.estado = 'P'
                                                      and    p.id not in (select distinct periodosliquidacion_id from contratospernominas where contratosperfecha_id = #{@contratospersona.idperfecha}))
                                  AND    f.fecha <= (SELECT MAX(fin)
                                                      FROM   periodosliquidaciones p
                                                      WHERE  p.termino = '#{@contratospersona.datogrupotermino.to_s}' AND p.estado = 'P'
                                                      AND    CURDATE() BETWEEN p.inicio AND (CASE WHEN DATE_FORMAT(p.fin,'%d') = '15' THEN p.fin ELSE LAST_DAY(p.fin) END))")


    respond_to { |format| format.js }
  end

  def create
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratospernovedad = Contratospernovedad.new(contratospernovedad_params)
    @contratospernovedad.contratospersona_id = @contratospersona.id
    @contratospernovedad.user_id = is_admin
    @contratospernovedad.contratosperfecha_id = @contratospersona.idperfecha
    @contratospernovedad.contratosgrupo_id = Contratosperfecha.find(@contratospersona.idperfecha).contratosgrupo_id rescue 0
    respond_to do |format|
      if @contratospernovedad.save
        ActiveRecord::Base.connection.execute("CALL prc_calculonovedad(#{@contratospernovedad.id})")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospernovedad } }
      end
    end
  end

  def update
    @contratospernovedad = Contratospernovedad.find(params[:id])
    @contratospersona = @contratospernovedad.contratospersona
    respond_to do |format|
      if @contratospernovedad.update(contratospernovedad_params)
        ActiveRecord::Base.connection.execute("CALL prc_calculonovedad(#{@contratospernovedad.id})")
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospernovedad } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratospernovedad.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratospernovedad
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratospernovedad = Contratospernovedad.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratospernovedad_params
    params.require(:contratospernovedad).permit!
  end
end
