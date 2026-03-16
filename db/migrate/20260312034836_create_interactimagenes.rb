class CreateInteractimagenes < ActiveRecord::Migration[5.0]
  def change
    create_table :interactimagenes do |t|
      t.integer  :interactividad_id
      t.string   :descripcion
      t.integer  :user_id
      t.string   :interactividad_file_name
      t.string   :interactividad_content_type
      t.bigint   :interactividad_file_size
      t.date     :interactividad_updated_at

      t.timestamps null: false
    end

    add_index :interactimagenes, :interactividad_id
    add_index :interactimagenes, :user_id
  end
end
