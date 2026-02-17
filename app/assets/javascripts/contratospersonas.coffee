jQuery ->
  $(document).on 'change', '#ubicacion_contrato_id', ->
    $.get '/contratospersonas/get_contratospersona_contrato_id', ubicacion_contrato_id: @value

  $(document).on 'change', '#contratospersona_genero', ->
    contratospersona_genero = @value
    $.get('/contratospersonas/get_contratospersona_genero', { contratospersona_genero: contratospersona_genero}, ->
      console.log 'success'
    ).fail ->
      console.log 'error'
