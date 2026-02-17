require 'test_helper'

class IparametrosformatosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @iparametrosformato = iparametrosformatos(:one)
  end

  test "should get index" do
    get iparametrosformatos_url
    assert_response :success
  end

  test "should get new" do
    get new_iparametrosformato_url
    assert_response :success
  end

  test "should create iparametrosformato" do
    assert_difference('Iparametrosformato.count') do
      post iparametrosformatos_url, params: { iparametrosformato: { formato_id: @iparametrosformato.formato_id, iparametro_id: @iparametrosformato.iparametro_id, orden: @iparametrosformato.orden } }
    end

    assert_redirected_to iparametrosformato_url(Iparametrosformato.last)
  end

  test "should show iparametrosformato" do
    get iparametrosformato_url(@iparametrosformato)
    assert_response :success
  end

  test "should get edit" do
    get edit_iparametrosformato_url(@iparametrosformato)
    assert_response :success
  end

  test "should update iparametrosformato" do
    patch iparametrosformato_url(@iparametrosformato), params: { iparametrosformato: { formato_id: @iparametrosformato.formato_id, iparametro_id: @iparametrosformato.iparametro_id, orden: @iparametrosformato.orden } }
    assert_redirected_to iparametrosformato_url(@iparametrosformato)
  end

  test "should destroy iparametrosformato" do
    assert_difference('Iparametrosformato.count', -1) do
      delete iparametrosformato_url(@iparametrosformato)
    end

    assert_redirected_to iparametrosformatos_url
  end
end
