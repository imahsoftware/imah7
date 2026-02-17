jQuery ->
  $(document).on 'change', '#contratosperfecha_contrato_id', ->
    $.get '/contratosperfechas/get_contratosperfecha_contrato_id', contratosperfecha_contrato_id: @value