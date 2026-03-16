class CreateInterventorias < ActiveRecord::Migration[5.0]
  def change
    create_table :interventorias do |t|
      t.integer  :contrato_id
      t.integer  :contratosperfecha_id
      t.integer  :user_id
      t.integer  :user_actualiza
      t.integer  :anno
      t.integer  :mes
      t.bigint   :valor_mes
      t.bigint   :salud
      t.bigint   :arl
      t.bigint   :interes_credito
      t.bigint   :salud_prepagada
      t.bigint   :dependientes
      t.bigint   :pension
      t.bigint   :afc
      t.bigint   :voluntarias
      t.bigint   :renta
      t.bigint   :base_uvt
      t.bigint   :retefuente383
      t.bigint   :retefuente384
      t.bigint   :subtotal
      t.bigint   :total
      t.bigint   :base_retefuente
      t.string   :observaciones, limit: 1100
      t.integer  :consecutivo
      t.bigint   :subtotalr
      t.bigint   :subtotalt
      t.string   :estado, limit: 40
      t.integer  :empleado_id
      t.integer  :dias
      t.string   :bloqueado, limit: 2
      t.string   :activo, limit: 1
      t.bigint   :valor_incr
      t.bigint   :total_rentas
      t.string   :version
      t.string   :etapa, limit: 5
      t.string   :gestion_humana
      t.integer  :diassuspension, default: 0
      t.string   :fin_anno, limit: 5
      t.string   :firma_digital_supervisor, limit: 30
      t.string   :firma_digital_empleado, limit: 30
      t.datetime :fecha_firma_supervisor
      t.datetime :fecha_firma_empleado

      t.timestamps null: false
    end
  end
end
