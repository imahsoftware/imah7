require 'test_helper'

class PersonasevaluacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @personasevaluacion = personasevaluaciones(:one)
  end

  test "should get index" do
    get personasevaluaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_personasevaluacion_url
    assert_response :success
  end

  test "should create personasevaluacion" do
    assert_difference('Personasevaluacion.count') do
      post personasevaluaciones_url, params: { personasevaluacion: { eva_1: @personasevaluacion.eva_1, eva_2: @personasevaluacion.eva_2, eva_3: @personasevaluacion.eva_3, eva_4: @personasevaluacion.eva_4, eva_5: @personasevaluacion.eva_5, eva_6: @personasevaluacion.eva_6, eva_7: @personasevaluacion.eva_7, eva_8: @personasevaluacion.eva_8, eva_9: @personasevaluacion.eva_9, persona_id: @personasevaluacion.persona_id } }
    end

    assert_redirected_to personasevaluacion_url(Personasevaluacion.last)
  end

  test "should show personasevaluacion" do
    get personasevaluacion_url(@personasevaluacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_personasevaluacion_url(@personasevaluacion)
    assert_response :success
  end

  test "should update personasevaluacion" do
    patch personasevaluacion_url(@personasevaluacion), params: { personasevaluacion: { eva_1: @personasevaluacion.eva_1, eva_2: @personasevaluacion.eva_2, eva_3: @personasevaluacion.eva_3, eva_4: @personasevaluacion.eva_4, eva_5: @personasevaluacion.eva_5, eva_6: @personasevaluacion.eva_6, eva_7: @personasevaluacion.eva_7, eva_8: @personasevaluacion.eva_8, eva_9: @personasevaluacion.eva_9, persona_id: @personasevaluacion.persona_id } }
    assert_redirected_to personasevaluacion_url(@personasevaluacion)
  end

  test "should destroy personasevaluacion" do
    assert_difference('Personasevaluacion.count', -1) do
      delete personasevaluacion_url(@personasevaluacion)
    end

    assert_redirected_to personasevaluaciones_url
  end
end
