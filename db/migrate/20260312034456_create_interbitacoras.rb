class CreateInterbitacoras < ActiveRecord::Migration[5.0]
  def change
    create_table :interbitacoras do |t|
      t.integer  :interventoria_id
      t.integer  :user_id
      t.string   :observacion, limit: 255

      t.timestamps null: false
    end

    add_index :interbitacoras, :interventoria_id
    add_index :interbitacoras, :user_id
  end
end
