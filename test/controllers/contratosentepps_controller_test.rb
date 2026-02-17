require 'test_helper'

class ContratosenteppsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosentepp = contratosentepps(:one)
  end

  test "should get index" do
    get contratosentepps_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosentepp_url
    assert_response :success
  end

  test "should create contratosentepp" do
    assert_difference('Contratosentepp.count') do
      post contratosentepps_url, params: { contratosentepp: { codigo_otp_env: @contratosentepp.codigo_otp_env, codigo_otp_fecha: @contratosentepp.codigo_otp_fecha, codigo_otp_firma: @contratosentepp.codigo_otp_firma, codigo_otp_rec: @contratosentepp.codigo_otp_rec, contrato_id: @contratosentepp.contrato_id, contratosperfecha_id: @contratosentepp.contratosperfecha_id, contratospersona_id: @contratosentepp.contratospersona_id, estado: @contratosentepp.estado, user_id: @contratosentepp.user_id } }
    end

    assert_redirected_to contratosentepp_url(Contratosentepp.last)
  end

  test "should show contratosentepp" do
    get contratosentepp_url(@contratosentepp)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosentepp_url(@contratosentepp)
    assert_response :success
  end

  test "should update contratosentepp" do
    patch contratosentepp_url(@contratosentepp), params: { contratosentepp: { codigo_otp_env: @contratosentepp.codigo_otp_env, codigo_otp_fecha: @contratosentepp.codigo_otp_fecha, codigo_otp_firma: @contratosentepp.codigo_otp_firma, codigo_otp_rec: @contratosentepp.codigo_otp_rec, contrato_id: @contratosentepp.contrato_id, contratosperfecha_id: @contratosentepp.contratosperfecha_id, contratospersona_id: @contratosentepp.contratospersona_id, estado: @contratosentepp.estado, user_id: @contratosentepp.user_id } }
    assert_redirected_to contratosentepp_url(@contratosentepp)
  end

  test "should destroy contratosentepp" do
    assert_difference('Contratosentepp.count', -1) do
      delete contratosentepp_url(@contratosentepp)
    end

    assert_redirected_to contratosentepps_url
  end
end
