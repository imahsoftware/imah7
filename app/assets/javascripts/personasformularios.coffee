jQuery ->
  $(document).on 'change', '#personasformulario_genero', ->
    personasformulario_genero = @value
    $.get('/personasformularios/get_personasformulario_genero', {personasformulario_genero: personasformulario_genero}, ->
      console.log 'success'
    ).fail ->
      console.log 'error'