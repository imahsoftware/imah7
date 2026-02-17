require 'test_helper'

class ContratosenteppsdetallesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosenteppsdetalle = contratosenteppsdetalles(:one)
  end

  test "should get index" do
    get contratosenteppsdetalles_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosenteppsdetalle_url
    assert_response :success
  end

  test "should create contratosenteppsdetalle" do
    assert_difference('Contratosenteppsdetalle.count') do
      post contratosenteppsdetalles_url, params: { contratosenteppsdetalle: { cantidad: @contratosenteppsdetalle.cantidad, contratosentepp_id: @contratosenteppsdetalle.contratosentepp_id, item: @contratosenteppsdetalle.item, observacion: @contratosenteppsdetalle.observacion } }
    end

    assert_redirected_to contratosenteppsdetalle_url(Contratosenteppsdetalle.last)
  end

  test "should show contratosenteppsdetalle" do
    get contratosenteppsdetalle_url(@contratosenteppsdetalle)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosenteppsdetalle_url(@contratosenteppsdetalle)
    assert_response :success
  end

  test "should update contratosenteppsdetalle" do
    patch contratosenteppsdetalle_url(@contratosenteppsdetalle), params: { contratosenteppsdetalle: { cantidad: @contratosenteppsdetalle.cantidad, contratosentepp_id: @contratosenteppsdetalle.contratosentepp_id, item: @contratosenteppsdetalle.item, observacion: @contratosenteppsdetalle.observacion } }
    assert_redirected_to contratosenteppsdetalle_url(@contratosenteppsdetalle)
  end

  test "should destroy contratosenteppsdetalle" do
    assert_difference('Contratosenteppsdetalle.count', -1) do
      delete contratosenteppsdetalle_url(@contratosenteppsdetalle)
    end

    assert_redirected_to contratosenteppsdetalles_url
  end
end
