require 'test_helper'

class TareasactdocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tareasactdoc = tareasactdocs(:one)
  end

  test "should get index" do
    get tareasactdocs_url
    assert_response :success
  end

  test "should get new" do
    get new_tareasactdoc_url
    assert_response :success
  end

  test "should create tareasactdoc" do
    assert_difference('Tareasactdoc.count') do
      post tareasactdocs_url, params: { tareasactdoc: { descripcion: @tareasactdoc.descripcion, documento_tarea: @tareasactdoc.documento_tarea, tareasactividad_id: @tareasactdoc.tareasactividad_id } }
    end

    assert_redirected_to tareasactdoc_url(Tareasactdoc.last)
  end

  test "should show tareasactdoc" do
    get tareasactdoc_url(@tareasactdoc)
    assert_response :success
  end

  test "should get edit" do
    get edit_tareasactdoc_url(@tareasactdoc)
    assert_response :success
  end

  test "should update tareasactdoc" do
    patch tareasactdoc_url(@tareasactdoc), params: { tareasactdoc: { descripcion: @tareasactdoc.descripcion, documento_tarea: @tareasactdoc.documento_tarea, tareasactividad_id: @tareasactdoc.tareasactividad_id } }
    assert_redirected_to tareasactdoc_url(@tareasactdoc)
  end

  test "should destroy tareasactdoc" do
    assert_difference('Tareasactdoc.count', -1) do
      delete tareasactdoc_url(@tareasactdoc)
    end

    assert_redirected_to tareasactdocs_url
  end
end
