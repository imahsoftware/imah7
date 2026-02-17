require 'test_helper'

class ContratosactejecucionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosactejecucion = contratosactejecuciones(:one)
  end

  test "should get index" do
    get contratosactejecuciones_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosactejecucion_url
    assert_response :success
  end

  test "should create contratosactejecucion" do
    assert_difference('Contratosactejecucion.count') do
      post contratosactejecuciones_url, params: { contratosactejecucion: { contratosactividad_id: @contratosactejecucion.contratosactividad_id, contratossede_id: @contratosactejecucion.contratossede_id, user_id: @contratosactejecucion.user_id } }
    end

    assert_redirected_to contratosactejecucion_url(Contratosactejecucion.last)
  end

  test "should show contratosactejecucion" do
    get contratosactejecucion_url(@contratosactejecucion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosactejecucion_url(@contratosactejecucion)
    assert_response :success
  end

  test "should update contratosactejecucion" do
    patch contratosactejecucion_url(@contratosactejecucion), params: { contratosactejecucion: { contratosactividad_id: @contratosactejecucion.contratosactividad_id, contratossede_id: @contratosactejecucion.contratossede_id, user_id: @contratosactejecucion.user_id } }
    assert_redirected_to contratosactejecucion_url(@contratosactejecucion)
  end

  test "should destroy contratosactejecucion" do
    assert_difference('Contratosactejecucion.count', -1) do
      delete contratosactejecucion_url(@contratosactejecucion)
    end

    assert_redirected_to contratosactejecuciones_url
  end
end
