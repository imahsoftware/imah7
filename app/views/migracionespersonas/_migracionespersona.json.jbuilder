json.extract! migracionespersona, :id, :user_id, :archivo_id, :lote, :identificacion, :nombre, :celular, :correo, :cargo_id, :observacion, :municipio, :departamento, :colegio, :estado_sms, :estado_correo, :estado_cargue, :error, :created_at, :updated_at
json.url migracionespersona_url(migracionespersona, format: :json)
