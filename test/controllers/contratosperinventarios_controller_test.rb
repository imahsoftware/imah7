require 'test_helper'

class ContratosperinventariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperinventario = contratosperinventarios(:one)
  end

  test "should get index" do
    get contratosperinventarios_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperinventario_url
    assert_response :success
  end

  test "should create contratosperinventario" do
    assert_difference('Contratosperinventario.count') do
      post contratosperinventarios_url, params: { contratosperinventario: { codigo_firma: @contratosperinventario.codigo_firma, codigo_otp: @contratosperinventario.codigo_otp, contratosperfecha_id: @contratosperinventario.contratosperfecha_id, contratospersona_id: @contratosperinventario.contratospersona_id, estado: @contratosperinventario.estado, fecha_firma: @contratosperinventario.fecha_firma, respuesta_otp: @contratosperinventario.respuesta_otp, user_id: @contratosperinventario.user_id } }
    end

    assert_redirected_to contratosperinventario_url(Contratosperinventario.last)
  end

  test "should show contratosperinventario" do
    get contratosperinventario_url(@contratosperinventario)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperinventario_url(@contratosperinventario)
    assert_response :success
  end

  test "should update contratosperinventario" do
    patch contratosperinventario_url(@contratosperinventario), params: { contratosperinventario: { codigo_firma: @contratosperinventario.codigo_firma, codigo_otp: @contratosperinventario.codigo_otp, contratosperfecha_id: @contratosperinventario.contratosperfecha_id, contratospersona_id: @contratosperinventario.contratospersona_id, estado: @contratosperinventario.estado, fecha_firma: @contratosperinventario.fecha_firma, respuesta_otp: @contratosperinventario.respuesta_otp, user_id: @contratosperinventario.user_id } }
    assert_redirected_to contratosperinventario_url(@contratosperinventario)
  end

  test "should destroy contratosperinventario" do
    assert_difference('Contratosperinventario.count', -1) do
      delete contratosperinventario_url(@contratosperinventario)
    end

    assert_redirected_to contratosperinventarios_url
  end
end
