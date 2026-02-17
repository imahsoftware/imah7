require 'test_helper'

class ContratoscargosactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratoscargosact = contratoscargosacts(:one)
  end

  test "should get index" do
    get contratoscargosacts_url
    assert_response :success
  end

  test "should get new" do
    get new_contratoscargosact_url
    assert_response :success
  end

  test "should create contratoscargosact" do
    assert_difference('Contratoscargosact.count') do
      post contratoscargosacts_url, params: { contratoscargosact: { contratoscargo_id: @contratoscargosact.contratoscargo_id, descripcion: @contratoscargosact.descripcion, estado: @contratoscargosact.estado, user_id: @contratoscargosact.user_id } }
    end

    assert_redirected_to contratoscargosact_url(Contratoscargosact.last)
  end

  test "should show contratoscargosact" do
    get contratoscargosact_url(@contratoscargosact)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratoscargosact_url(@contratoscargosact)
    assert_response :success
  end

  test "should update contratoscargosact" do
    patch contratoscargosact_url(@contratoscargosact), params: { contratoscargosact: { contratoscargo_id: @contratoscargosact.contratoscargo_id, descripcion: @contratoscargosact.descripcion, estado: @contratoscargosact.estado, user_id: @contratoscargosact.user_id } }
    assert_redirected_to contratoscargosact_url(@contratoscargosact)
  end

  test "should destroy contratoscargosact" do
    assert_difference('Contratoscargosact.count', -1) do
      delete contratoscargosact_url(@contratoscargosact)
    end

    assert_redirected_to contratoscargosacts_url
  end
end
