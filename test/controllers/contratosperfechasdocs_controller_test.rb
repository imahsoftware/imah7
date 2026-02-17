require 'test_helper'

class ContratosperfechasdocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperfechasdoc = contratosperfechasdocs(:one)
  end

  test "should get index" do
    get contratosperfechasdocs_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperfechasdoc_url
    assert_response :success
  end

  test "should create contratosperfechasdoc" do
    assert_difference('Contratosperfechasdoc.count') do
      post contratosperfechasdocs_url, params: { contratosperfechasdoc: { contratosperfecha_id: @contratosperfechasdoc.contratosperfecha_id, descripcion: @contratosperfechasdoc.descripcion, soporte_digital: @contratosperfechasdoc.soporte_digital } }
    end

    assert_redirected_to contratosperfechasdoc_url(Contratosperfechasdoc.last)
  end

  test "should show contratosperfechasdoc" do
    get contratosperfechasdoc_url(@contratosperfechasdoc)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperfechasdoc_url(@contratosperfechasdoc)
    assert_response :success
  end

  test "should update contratosperfechasdoc" do
    patch contratosperfechasdoc_url(@contratosperfechasdoc), params: { contratosperfechasdoc: { contratosperfecha_id: @contratosperfechasdoc.contratosperfecha_id, descripcion: @contratosperfechasdoc.descripcion, soporte_digital: @contratosperfechasdoc.soporte_digital } }
    assert_redirected_to contratosperfechasdoc_url(@contratosperfechasdoc)
  end

  test "should destroy contratosperfechasdoc" do
    assert_difference('Contratosperfechasdoc.count', -1) do
      delete contratosperfechasdoc_url(@contratosperfechasdoc)
    end

    assert_redirected_to contratosperfechasdocs_url
  end
end
