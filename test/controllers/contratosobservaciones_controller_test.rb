require 'test_helper'

class ContratosobservacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosobservacion = contratosobservaciones(:one)
  end

  test "should get index" do
    get contratosobservaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosobservacion_url
    assert_response :success
  end

  test "should create contratosobservacion" do
    assert_difference('Contratosobservacion.count') do
      post contratosobservaciones_url, params: { contratosobservacion: { contrato_id: @contratosobservacion.contrato_id, observacion: @contratosobservacion.observacion, user_id: @contratosobservacion.user_id } }
    end

    assert_redirected_to contratosobservacion_url(Contratosobservacion.last)
  end

  test "should show contratosobservacion" do
    get contratosobservacion_url(@contratosobservacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosobservacion_url(@contratosobservacion)
    assert_response :success
  end

  test "should update contratosobservacion" do
    patch contratosobservacion_url(@contratosobservacion), params: { contratosobservacion: { contrato_id: @contratosobservacion.contrato_id, observacion: @contratosobservacion.observacion, user_id: @contratosobservacion.user_id } }
    assert_redirected_to contratosobservacion_url(@contratosobservacion)
  end

  test "should destroy contratosobservacion" do
    assert_difference('Contratosobservacion.count', -1) do
      delete contratosobservacion_url(@contratosobservacion)
    end

    assert_redirected_to contratosobservaciones_url
  end
end
