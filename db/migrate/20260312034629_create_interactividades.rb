class CreateInteractividades < ActiveRecord::Migration[5.0]
  def change
    create_table :interactividades do |t|
      t.integer  :interventoria_id
      t.text     :actividad
      t.text     :desarrollo
      t.integer  :user_id
      t.integer  :useract_id
      t.integer  :consecutivo
      t.string   :estado_i, limit: 20
      t.string   :estado_g, limit: 20
      t.string   :bloqueado, limit: 2

      t.timestamps null: false
    end

    add_index :interactividades, :interventoria_id
    add_index :interactividades, :user_id
    add_index :interactividades, [:interventoria_id, :consecutivo]
  end
end
