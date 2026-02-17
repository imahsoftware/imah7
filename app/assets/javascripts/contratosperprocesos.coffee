jQuery ->
  $(document).on 'change', '#contratosperprocitacion_estado', ->
    contratosperprocitacion_estado = @value
    customParam1 = $('#tu_input_id').data('custom_param1')  # Reemplaza 'tu_input_id' con el ID de tu input
    customParam2 = $('#tu_input_id').data('custom_param2')  # Reemplaza 'tu_input_id' con el ID de tu input

    $.get('/contratosperprocesos/get_contratosperprocitaciones_estado', {
      contratosperprocitacion_estado: contratosperprocitacion_estado,
      custom_param1: customParam1,
      custom_param2: customParam2
    }, ->
      console.log 'success'
    ).fail ->
      console.log 'error'
