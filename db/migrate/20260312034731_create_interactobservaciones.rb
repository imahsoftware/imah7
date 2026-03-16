class CreateInteractobservaciones < ActiveRecord::Migration[5.0]
  def change
    create_table :interactobservaciones do |t|
      t.integer  :interactividad_id
      t.integer  :user_id
      t.text     :observaciones

      t.timestamps null: false
    end

    add_index :interactobservaciones, :interactividad_id
    add_index :interactobservaciones, :user_id
  end
end
