require 'test_helper'

class ContratosactcodigosinfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosactcodigosinfo = contratosactcodigosinfos(:one)
  end

  test "should get index" do
    get contratosactcodigosinfos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosactcodigosinfo_url
    assert_response :success
  end

  test "should create contratosactcodigosinfo" do
    assert_difference('Contratosactcodigosinfo.count') do
      post contratosactcodigosinfos_url, params: { contratosactcodigosinfo: { contratossede_id: @contratosactcodigosinfo.contratossede_id, fecha: @contratosactcodigosinfo.fecha, nodo: @contratosactcodigosinfo.nodo, rsteva_10: @contratosactcodigosinfo.rsteva_10, rsteva_11: @contratosactcodigosinfo.rsteva_11, rsteva_12: @contratosactcodigosinfo.rsteva_12, rsteva_13: @contratosactcodigosinfo.rsteva_13, rsteva_14: @contratosactcodigosinfo.rsteva_14, rsteva_15: @contratosactcodigosinfo.rsteva_15, rsteva_16: @contratosactcodigosinfo.rsteva_16, rsteva_17: @contratosactcodigosinfo.rsteva_17, rsteva_18: @contratosactcodigosinfo.rsteva_18, rsteva_19: @contratosactcodigosinfo.rsteva_19, rsteva_1: @contratosactcodigosinfo.rsteva_1, rsteva_20: @contratosactcodigosinfo.rsteva_20, rsteva_21: @contratosactcodigosinfo.rsteva_21, rsteva_22: @contratosactcodigosinfo.rsteva_22, rsteva_23: @contratosactcodigosinfo.rsteva_23, rsteva_24: @contratosactcodigosinfo.rsteva_24, rsteva_2: @contratosactcodigosinfo.rsteva_2, rsteva_3: @contratosactcodigosinfo.rsteva_3, rsteva_44: @contratosactcodigosinfo.rsteva_44, rsteva_45: @contratosactcodigosinfo.rsteva_45, rsteva_46: @contratosactcodigosinfo.rsteva_46, rsteva_47: @contratosactcodigosinfo.rsteva_47, rsteva_48: @contratosactcodigosinfo.rsteva_48, rsteva_49: @contratosactcodigosinfo.rsteva_49, rsteva_4: @contratosactcodigosinfo.rsteva_4, rsteva_50: @contratosactcodigosinfo.rsteva_50, rsteva_51: @contratosactcodigosinfo.rsteva_51, rsteva_5: @contratosactcodigosinfo.rsteva_5, rsteva_6: @contratosactcodigosinfo.rsteva_6, rsteva_7: @contratosactcodigosinfo.rsteva_7, rsteva_8: @contratosactcodigosinfo.rsteva_8, rsteva_9: @contratosactcodigosinfo.rsteva_9, user_id: @contratosactcodigosinfo.user_id } }
    end

    assert_redirected_to contratosactcodigosinfo_url(Contratosactcodigosinfo.last)
  end

  test "should show contratosactcodigosinfo" do
    get contratosactcodigosinfo_url(@contratosactcodigosinfo)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosactcodigosinfo_url(@contratosactcodigosinfo)
    assert_response :success
  end

  test "should update contratosactcodigosinfo" do
    patch contratosactcodigosinfo_url(@contratosactcodigosinfo), params: { contratosactcodigosinfo: { contratossede_id: @contratosactcodigosinfo.contratossede_id, fecha: @contratosactcodigosinfo.fecha, nodo: @contratosactcodigosinfo.nodo, rsteva_10: @contratosactcodigosinfo.rsteva_10, rsteva_11: @contratosactcodigosinfo.rsteva_11, rsteva_12: @contratosactcodigosinfo.rsteva_12, rsteva_13: @contratosactcodigosinfo.rsteva_13, rsteva_14: @contratosactcodigosinfo.rsteva_14, rsteva_15: @contratosactcodigosinfo.rsteva_15, rsteva_16: @contratosactcodigosinfo.rsteva_16, rsteva_17: @contratosactcodigosinfo.rsteva_17, rsteva_18: @contratosactcodigosinfo.rsteva_18, rsteva_19: @contratosactcodigosinfo.rsteva_19, rsteva_1: @contratosactcodigosinfo.rsteva_1, rsteva_20: @contratosactcodigosinfo.rsteva_20, rsteva_21: @contratosactcodigosinfo.rsteva_21, rsteva_22: @contratosactcodigosinfo.rsteva_22, rsteva_23: @contratosactcodigosinfo.rsteva_23, rsteva_24: @contratosactcodigosinfo.rsteva_24, rsteva_2: @contratosactcodigosinfo.rsteva_2, rsteva_3: @contratosactcodigosinfo.rsteva_3, rsteva_44: @contratosactcodigosinfo.rsteva_44, rsteva_45: @contratosactcodigosinfo.rsteva_45, rsteva_46: @contratosactcodigosinfo.rsteva_46, rsteva_47: @contratosactcodigosinfo.rsteva_47, rsteva_48: @contratosactcodigosinfo.rsteva_48, rsteva_49: @contratosactcodigosinfo.rsteva_49, rsteva_4: @contratosactcodigosinfo.rsteva_4, rsteva_50: @contratosactcodigosinfo.rsteva_50, rsteva_51: @contratosactcodigosinfo.rsteva_51, rsteva_5: @contratosactcodigosinfo.rsteva_5, rsteva_6: @contratosactcodigosinfo.rsteva_6, rsteva_7: @contratosactcodigosinfo.rsteva_7, rsteva_8: @contratosactcodigosinfo.rsteva_8, rsteva_9: @contratosactcodigosinfo.rsteva_9, user_id: @contratosactcodigosinfo.user_id } }
    assert_redirected_to contratosactcodigosinfo_url(@contratosactcodigosinfo)
  end

  test "should destroy contratosactcodigosinfo" do
    assert_difference('Contratosactcodigosinfo.count', -1) do
      delete contratosactcodigosinfo_url(@contratosactcodigosinfo)
    end

    assert_redirected_to contratosactcodigosinfos_url
  end
end
