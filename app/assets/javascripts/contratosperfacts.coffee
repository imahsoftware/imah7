jQuery ->
  $(document).on 'change', '#contratosperfact_contrato_id', ->
    $.get '/contratosperfacts/get_contratosperfact_contrato_id', contratosperfact_contrato_id: @value
