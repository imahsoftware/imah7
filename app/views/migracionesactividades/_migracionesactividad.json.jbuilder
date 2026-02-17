json.extract! migracionesactividad, :id, :user_id, :archivo_id, :estado, :tareasactividad_id, :dias, :estado_actividad, :user_persona, :created_at, :updated_at
json.url migracionesactividad_url(migracionesactividad, format: :json)
