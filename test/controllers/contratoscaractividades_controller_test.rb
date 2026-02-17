require 'test_helper'

class ContratoscaractividadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratoscaractividad = contratoscaractividades(:one)
  end

  test "should get index" do
    get contratoscaractividades_url
    assert_response :success
  end

  test "should get new" do
    get new_contratoscaractividad_url
    assert_response :success
  end

  test "should create contratoscaractividad" do
    assert_difference('Contratoscaractividad.count') do
      post contratoscaractividades_url, params: { contratoscaractividad: { actividad: @contratoscaractividad.actividad, contratoscargo_id: @contratoscaractividad.contratoscargo_id, user_id: @contratoscaractividad.user_id } }
    end

    assert_redirected_to contratoscaractividad_url(Contratoscaractividad.last)
  end

  test "should show contratoscaractividad" do
    get contratoscaractividad_url(@contratoscaractividad)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratoscaractividad_url(@contratoscaractividad)
    assert_response :success
  end

  test "should update contratoscaractividad" do
    patch contratoscaractividad_url(@contratoscaractividad), params: { contratoscaractividad: { actividad: @contratoscaractividad.actividad, contratoscargo_id: @contratoscaractividad.contratoscargo_id, user_id: @contratoscaractividad.user_id } }
    assert_redirected_to contratoscaractividad_url(@contratoscaractividad)
  end

  test "should destroy contratoscaractividad" do
    assert_difference('Contratoscaractividad.count', -1) do
      delete contratoscaractividad_url(@contratoscaractividad)
    end

    assert_redirected_to contratoscaractividades_url
  end
end
