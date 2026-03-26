class AddEsPagoSsToContratoscargosacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contratoscargosacts, :es_pago_ss, :string, default: 'NO', after: :estado
  end
end
