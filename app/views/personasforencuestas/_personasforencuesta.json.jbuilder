json.extract! personasforencuesta, :id, :personasformulario_id, :encuesta_id, :encuestaspregunta_id, :encuestapreopcion_id, :calificacion, :created_at, :updated_at
json.url personasforencuesta_url(personasforencuesta, format: :json)
