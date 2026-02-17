require 'test_helper'

class ContratosperfechasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperfecha = contratosperfechas(:one)
  end

  test "should get index" do
    get contratosperfechas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperfecha_url
    assert_response :success
  end

  test "should create contratosperfecha" do
    assert_difference('Contratosperfecha.count') do
      post contratosperfechas_url, params: { contratosperfecha: { contrato_id: @contratosperfecha.contrato_id, fecha_fin: @contratosperfecha.fecha_fin, fecha_inicio: @contratosperfecha.fecha_inicio, salario: @contratosperfecha.salario, user_id: @contratosperfecha.user_id } }
    end

    assert_redirected_to contratosperfecha_url(Contratosperfecha.last)
  end

  test "should show contratosperfecha" do
    get contratosperfecha_url(@contratosperfecha)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperfecha_url(@contratosperfecha)
    assert_response :success
  end

  test "should update contratosperfecha" do
    patch contratosperfecha_url(@contratosperfecha), params: { contratosperfecha: { contrato_id: @contratosperfecha.contrato_id, fecha_fin: @contratosperfecha.fecha_fin, fecha_inicio: @contratosperfecha.fecha_inicio, salario: @contratosperfecha.salario, user_id: @contratosperfecha.user_id } }
    assert_redirected_to contratosperfecha_url(@contratosperfecha)
  end

  test "should destroy contratosperfecha" do
    assert_difference('Contratosperfecha.count', -1) do
      delete contratosperfecha_url(@contratosperfecha)
    end

    assert_redirected_to contratosperfechas_url
  end
end
