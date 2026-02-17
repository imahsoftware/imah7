jQuery ->
  $(document).on 'change', '#ubicacion_contrato_id', ->
    $.get '/contratospermasivas/get_contratospermasiva_contrato_id', ubicacion_contrato_id: @value