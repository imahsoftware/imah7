json.extract! migracionescuenta, :id, :user_id, :archivo_id, :estado, :identificacion, :nro_cuenta, :created_at, :updated_at
json.url migracionescuenta_url(migracionescuenta, format: :json)
