jQuery ->
  $(document).on 'change', '#ubicacion_contrato_id', ->
    $.get '/contratospernominas/get_contratospernomina_contrato_id', ubicacion_contrato_id: @value