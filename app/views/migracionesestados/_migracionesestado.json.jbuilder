json.extract! migracionesestado, :id, :personasformulario_id, :user_id, :archivo_id, :estado, :observacion_eps, :estado_cargue, :error, :tipo, :created_at, :updated_at
json.url migracionesestado_url(migracionesestado, format: :json)
