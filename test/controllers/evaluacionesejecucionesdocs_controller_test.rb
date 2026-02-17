require 'test_helper'

class EvaluacionesejecucionesdocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @evaluacionesejecucionesdoc = evaluacionesejecucionesdocs(:one)
  end

  test "should get index" do
    get evaluacionesejecucionesdocs_url
    assert_response :success
  end

  test "should get new" do
    get new_evaluacionesejecucionesdoc_url
    assert_response :success
  end

  test "should create evaluacionesejecucionesdoc" do
    assert_difference('Evaluacionesejecucionesdoc.count') do
      post evaluacionesejecucionesdocs_url, params: { evaluacionesejecucionesdoc: { docevaluacion: @evaluacionesejecucionesdoc.docevaluacion, evaluacionesejecucion_id: @evaluacionesejecucionesdoc.evaluacionesejecucion_id, tipo: @evaluacionesejecucionesdoc.tipo, user_id: @evaluacionesejecucionesdoc.user_id } }
    end

    assert_redirected_to evaluacionesejecucionesdoc_url(Evaluacionesejecucionesdoc.last)
  end

  test "should show evaluacionesejecucionesdoc" do
    get evaluacionesejecucionesdoc_url(@evaluacionesejecucionesdoc)
    assert_response :success
  end

  test "should get edit" do
    get edit_evaluacionesejecucionesdoc_url(@evaluacionesejecucionesdoc)
    assert_response :success
  end

  test "should update evaluacionesejecucionesdoc" do
    patch evaluacionesejecucionesdoc_url(@evaluacionesejecucionesdoc), params: { evaluacionesejecucionesdoc: { docevaluacion: @evaluacionesejecucionesdoc.docevaluacion, evaluacionesejecucion_id: @evaluacionesejecucionesdoc.evaluacionesejecucion_id, tipo: @evaluacionesejecucionesdoc.tipo, user_id: @evaluacionesejecucionesdoc.user_id } }
    assert_redirected_to evaluacionesejecucionesdoc_url(@evaluacionesejecucionesdoc)
  end

  test "should destroy evaluacionesejecucionesdoc" do
    assert_difference('Evaluacionesejecucionesdoc.count', -1) do
      delete evaluacionesejecucionesdoc_url(@evaluacionesejecucionesdoc)
    end

    assert_redirected_to evaluacionesejecucionesdocs_url
  end
end
