require 'test_helper'

class ContratosperprosancionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperprosancion = contratosperprosanciones(:one)
  end

  test "should get index" do
    get contratosperprosanciones_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperprosancion_url
    assert_response :success
  end

  test "should create contratosperprosancion" do
    assert_difference('Contratosperprosancion.count') do
      post contratosperprosanciones_url, params: { contratosperprosancion: { contratosperproceso_id: @contratosperprosancion.contratosperproceso_id, contratospersona_id: @contratosperprosancion.contratospersona_id, reglamento: @contratosperprosancion.reglamento, sancion: @contratosperprosancion.sancion, user_id: @contratosperprosancion.user_id } }
    end

    assert_redirected_to contratosperprosancion_url(Contratosperprosancion.last)
  end

  test "should show contratosperprosancion" do
    get contratosperprosancion_url(@contratosperprosancion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperprosancion_url(@contratosperprosancion)
    assert_response :success
  end

  test "should update contratosperprosancion" do
    patch contratosperprosancion_url(@contratosperprosancion), params: { contratosperprosancion: { contratosperproceso_id: @contratosperprosancion.contratosperproceso_id, contratospersona_id: @contratosperprosancion.contratospersona_id, reglamento: @contratosperprosancion.reglamento, sancion: @contratosperprosancion.sancion, user_id: @contratosperprosancion.user_id } }
    assert_redirected_to contratosperprosancion_url(@contratosperprosancion)
  end

  test "should destroy contratosperprosancion" do
    assert_difference('Contratosperprosancion.count', -1) do
      delete contratosperprosancion_url(@contratosperprosancion)
    end

    assert_redirected_to contratosperprosanciones_url
  end
end
