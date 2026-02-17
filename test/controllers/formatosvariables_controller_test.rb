require 'test_helper'

class FormatosvariablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @formatosvariable = formatosvariables(:one)
  end

  test "should get index" do
    get formatosvariables_url
    assert_response :success
  end

  test "should get new" do
    get new_formatosvariable_url
    assert_response :success
  end

  test "should create formatosvariable" do
    assert_difference('Formatosvariable.count') do
      post formatosvariables_url, params: { formatosvariable: { formato_id: @formatosvariable.formato_id, orden: @formatosvariable.orden, seccion: @formatosvariable.seccion, titulo: @formatosvariable.titulo, valor: @formatosvariable.valor, variable_id: @formatosvariable.variable_id } }
    end

    assert_redirected_to formatosvariable_url(Formatosvariable.last)
  end

  test "should show formatosvariable" do
    get formatosvariable_url(@formatosvariable)
    assert_response :success
  end

  test "should get edit" do
    get edit_formatosvariable_url(@formatosvariable)
    assert_response :success
  end

  test "should update formatosvariable" do
    patch formatosvariable_url(@formatosvariable), params: { formatosvariable: { formato_id: @formatosvariable.formato_id, orden: @formatosvariable.orden, seccion: @formatosvariable.seccion, titulo: @formatosvariable.titulo, valor: @formatosvariable.valor, variable_id: @formatosvariable.variable_id } }
    assert_redirected_to formatosvariable_url(@formatosvariable)
  end

  test "should destroy formatosvariable" do
    assert_difference('Formatosvariable.count', -1) do
      delete formatosvariable_url(@formatosvariable)
    end

    assert_redirected_to formatosvariables_url
  end
end
