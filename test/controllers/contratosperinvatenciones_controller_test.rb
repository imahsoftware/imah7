require 'test_helper'

class ContratosperinvatencionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperinvatencion = contratosperinvatenciones(:one)
  end

  test "should get index" do
    get contratosperinvatenciones_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperinvatencion_url
    assert_response :success
  end

  test "should create contratosperinvatencion" do
    assert_difference('Contratosperinvatencion.count') do
      post contratosperinvatenciones_url, params: { contratosperinvatencion: { nombre: @contratosperinvatencion.nombre } }
    end

    assert_redirected_to contratosperinvatencion_url(Contratosperinvatencion.last)
  end

  test "should show contratosperinvatencion" do
    get contratosperinvatencion_url(@contratosperinvatencion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperinvatencion_url(@contratosperinvatencion)
    assert_response :success
  end

  test "should update contratosperinvatencion" do
    patch contratosperinvatencion_url(@contratosperinvatencion), params: { contratosperinvatencion: { nombre: @contratosperinvatencion.nombre } }
    assert_redirected_to contratosperinvatencion_url(@contratosperinvatencion)
  end

  test "should destroy contratosperinvatencion" do
    assert_difference('Contratosperinvatencion.count', -1) do
      delete contratosperinvatencion_url(@contratosperinvatencion)
    end

    assert_redirected_to contratosperinvatenciones_url
  end
end
