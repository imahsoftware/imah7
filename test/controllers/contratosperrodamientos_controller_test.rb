require 'test_helper'

class ContratosperrodamientosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperrodamiento = contratosperrodamientos(:one)
  end

  test "should get index" do
    get contratosperrodamientos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperrodamiento_url
    assert_response :success
  end

  test "should create contratosperrodamiento" do
    assert_difference('Contratosperrodamiento.count') do
      post contratosperrodamientos_url, params: { contratosperrodamiento: { contratospersona_id: @contratosperrodamiento.contratospersona_id, estado: @contratosperrodamiento.estado, termino_descuento: @contratosperrodamiento.termino_descuento, user_actualiza: @contratosperrodamiento.user_actualiza, user_id: @contratosperrodamiento.user_id, valor: @contratosperrodamiento.valor } }
    end

    assert_redirected_to contratosperrodamiento_url(Contratosperrodamiento.last)
  end

  test "should show contratosperrodamiento" do
    get contratosperrodamiento_url(@contratosperrodamiento)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperrodamiento_url(@contratosperrodamiento)
    assert_response :success
  end

  test "should update contratosperrodamiento" do
    patch contratosperrodamiento_url(@contratosperrodamiento), params: { contratosperrodamiento: { contratospersona_id: @contratosperrodamiento.contratospersona_id, estado: @contratosperrodamiento.estado, termino_descuento: @contratosperrodamiento.termino_descuento, user_actualiza: @contratosperrodamiento.user_actualiza, user_id: @contratosperrodamiento.user_id, valor: @contratosperrodamiento.valor } }
    assert_redirected_to contratosperrodamiento_url(@contratosperrodamiento)
  end

  test "should destroy contratosperrodamiento" do
    assert_difference('Contratosperrodamiento.count', -1) do
      delete contratosperrodamiento_url(@contratosperrodamiento)
    end

    assert_redirected_to contratosperrodamientos_url
  end
end
