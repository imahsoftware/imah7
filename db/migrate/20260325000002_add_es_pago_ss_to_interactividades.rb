class AddEsPagoSsToInteractividades < ActiveRecord::Migration[5.0]
  def change
    add_column :interactividades, :es_pago_ss, :string, default: 'NO', after: :bloqueado
  end
end
