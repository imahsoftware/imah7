jQuery ->
  $(document).on 'change', '#archivo_migracion', ->
    $.get '/archivos/get_tipoproceso', { archivo_migracion: @value }
