json.extract! migracionesinsumo, :id, :user_id, :archivo_id, :estado, :contrato_id, :insumo_id, :cantidad_mensual, :precio_unitario, :descuento, :precio_condescuento, :total, :created_at, :updated_at
json.url migracionesinsumo_url(migracionesinsumo, format: :json)
