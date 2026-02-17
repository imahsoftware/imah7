jQuery ->
  $(document).on 'change', '#veriservicio_contrato_id', ->
    veriservicio_contrato_id = @value
    $.get('/veriservicios/get_contratossede_id', {veriservicio_contrato_id: veriservicio_contrato_id}, ->
      console.log 'success'
    ).fail ->
      console.log 'error'