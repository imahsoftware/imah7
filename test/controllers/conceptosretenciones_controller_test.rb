require 'test_helper'

class ConceptosretencionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @conceptosretencion = conceptosretenciones(:one)
  end

  test "should get index" do
    get conceptosretenciones_url
    assert_response :success
  end

  test "should get new" do
    get new_conceptosretencion_url
    assert_response :success
  end

  test "should create conceptosretencion" do
    assert_difference('Conceptosretencion.count') do
      post conceptosretenciones_url, params: { conceptosretencion: { concepto_id: @conceptosretencion.concepto_id, tipospretencion_id: @conceptosretencion.tipospretencion_id } }
    end

    assert_redirected_to conceptosretencion_url(Conceptosretencion.last)
  end

  test "should show conceptosretencion" do
    get conceptosretencion_url(@conceptosretencion)
    assert_response :success
  end

  test "should get edit" do
    get edit_conceptosretencion_url(@conceptosretencion)
    assert_response :success
  end

  test "should update conceptosretencion" do
    patch conceptosretencion_url(@conceptosretencion), params: { conceptosretencion: { concepto_id: @conceptosretencion.concepto_id, tipospretencion_id: @conceptosretencion.tipospretencion_id } }
    assert_redirected_to conceptosretencion_url(@conceptosretencion)
  end

  test "should destroy conceptosretencion" do
    assert_difference('Conceptosretencion.count', -1) do
      delete conceptosretencion_url(@conceptosretencion)
    end

    assert_redirected_to conceptosretenciones_url
  end
end
