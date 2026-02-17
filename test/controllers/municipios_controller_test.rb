require 'test_helper'

class MunicipiosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @municipio = municipios(:one)
  end

  test "should get index" do
    get municipios_url
    assert_response :success
  end

  test "should get new" do
    get new_municipio_url
    assert_response :success
  end

  test "should create municipio" do
    assert_difference('Municipio.count') do
      post municipios_url, params: { municipio: { autobuscar: @municipio.autobuscar, coddian_departamento: @municipio.coddian_departamento, coddian_municipio: @municipio.coddian_municipio, departamento: @municipio.departamento, descripcion: @municipio.descripcion } }
    end

    assert_redirected_to municipio_url(Municipio.last)
  end

  test "should show municipio" do
    get municipio_url(@municipio)
    assert_response :success
  end

  test "should get edit" do
    get edit_municipio_url(@municipio)
    assert_response :success
  end

  test "should update municipio" do
    patch municipio_url(@municipio), params: { municipio: { autobuscar: @municipio.autobuscar, coddian_departamento: @municipio.coddian_departamento, coddian_municipio: @municipio.coddian_municipio, departamento: @municipio.departamento, descripcion: @municipio.descripcion } }
    assert_redirected_to municipio_url(@municipio)
  end

  test "should destroy municipio" do
    assert_difference('Municipio.count', -1) do
      delete municipio_url(@municipio)
    end

    assert_redirected_to municipios_url
  end
end
