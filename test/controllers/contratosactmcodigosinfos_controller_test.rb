require 'test_helper'

class ContratosactmcodigosinfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosactmcodigosinfo = contratosactmcodigosinfos(:one)
  end

  test "should get index" do
    get contratosactmcodigosinfos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosactmcodigosinfo_url
    assert_response :success
  end

  test "should create contratosactmcodigosinfo" do
    assert_difference('Contratosactmcodigosinfo.count') do
      post contratosactmcodigosinfos_url, params: { contratosactmcodigosinfo: { contratossede_id: @contratosactmcodigosinfo.contratossede_id, fecha: @contratosactmcodigosinfo.fecha, nodo: @contratosactmcodigosinfo.nodo, rsteva_10: @contratosactmcodigosinfo.rsteva_10, rsteva_11: @contratosactmcodigosinfo.rsteva_11, rsteva_12: @contratosactmcodigosinfo.rsteva_12, rsteva_13: @contratosactmcodigosinfo.rsteva_13, rsteva_14: @contratosactmcodigosinfo.rsteva_14, rsteva_15: @contratosactmcodigosinfo.rsteva_15, rsteva_16: @contratosactmcodigosinfo.rsteva_16, rsteva_17: @contratosactmcodigosinfo.rsteva_17, rsteva_18: @contratosactmcodigosinfo.rsteva_18, rsteva_19: @contratosactmcodigosinfo.rsteva_19, rsteva_20: @contratosactmcodigosinfo.rsteva_20, rsteva_21: @contratosactmcodigosinfo.rsteva_21, rsteva_22: @contratosactmcodigosinfo.rsteva_22, rsteva_23: @contratosactmcodigosinfo.rsteva_23, rsteva_24: @contratosactmcodigosinfo.rsteva_24, rsteva_25: @contratosactmcodigosinfo.rsteva_25, rsteva_26: @contratosactmcodigosinfo.rsteva_26, rsteva_27: @contratosactmcodigosinfo.rsteva_27, rsteva_28: @contratosactmcodigosinfo.rsteva_28, rsteva_29: @contratosactmcodigosinfo.rsteva_29, rsteva_2: @contratosactmcodigosinfo.rsteva_2, rsteva_30: @contratosactmcodigosinfo.rsteva_30, rsteva_31: @contratosactmcodigosinfo.rsteva_31, rsteva_32: @contratosactmcodigosinfo.rsteva_32, rsteva_33: @contratosactmcodigosinfo.rsteva_33, rsteva_34: @contratosactmcodigosinfo.rsteva_34, rsteva_35: @contratosactmcodigosinfo.rsteva_35, rsteva_36: @contratosactmcodigosinfo.rsteva_36, rsteva_37: @contratosactmcodigosinfo.rsteva_37, rsteva_38: @contratosactmcodigosinfo.rsteva_38, rsteva_39: @contratosactmcodigosinfo.rsteva_39, rsteva_3: @contratosactmcodigosinfo.rsteva_3, rsteva_40: @contratosactmcodigosinfo.rsteva_40, rsteva_41: @contratosactmcodigosinfo.rsteva_41, rsteva_42: @contratosactmcodigosinfo.rsteva_42, rsteva_43: @contratosactmcodigosinfo.rsteva_43, rsteva_44: @contratosactmcodigosinfo.rsteva_44, rsteva_45: @contratosactmcodigosinfo.rsteva_45, rsteva_46: @contratosactmcodigosinfo.rsteva_46, rsteva_47: @contratosactmcodigosinfo.rsteva_47, rsteva_48: @contratosactmcodigosinfo.rsteva_48, rsteva_49: @contratosactmcodigosinfo.rsteva_49, rsteva_4: @contratosactmcodigosinfo.rsteva_4, rsteva_50: @contratosactmcodigosinfo.rsteva_50, rsteva_51: @contratosactmcodigosinfo.rsteva_51, rsteva_52: @contratosactmcodigosinfo.rsteva_52, rsteva_5: @contratosactmcodigosinfo.rsteva_5, rsteva_6: @contratosactmcodigosinfo.rsteva_6, rsteva_7: @contratosactmcodigosinfo.rsteva_7, rsteva_8: @contratosactmcodigosinfo.rsteva_8, rsteva_9: @contratosactmcodigosinfo.rsteva_9, user_id: @contratosactmcodigosinfo.user_id } }
    end

    assert_redirected_to contratosactmcodigosinfo_url(Contratosactmcodigosinfo.last)
  end

  test "should show contratosactmcodigosinfo" do
    get contratosactmcodigosinfo_url(@contratosactmcodigosinfo)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosactmcodigosinfo_url(@contratosactmcodigosinfo)
    assert_response :success
  end

  test "should update contratosactmcodigosinfo" do
    patch contratosactmcodigosinfo_url(@contratosactmcodigosinfo), params: { contratosactmcodigosinfo: { contratossede_id: @contratosactmcodigosinfo.contratossede_id, fecha: @contratosactmcodigosinfo.fecha, nodo: @contratosactmcodigosinfo.nodo, rsteva_10: @contratosactmcodigosinfo.rsteva_10, rsteva_11: @contratosactmcodigosinfo.rsteva_11, rsteva_12: @contratosactmcodigosinfo.rsteva_12, rsteva_13: @contratosactmcodigosinfo.rsteva_13, rsteva_14: @contratosactmcodigosinfo.rsteva_14, rsteva_15: @contratosactmcodigosinfo.rsteva_15, rsteva_16: @contratosactmcodigosinfo.rsteva_16, rsteva_17: @contratosactmcodigosinfo.rsteva_17, rsteva_18: @contratosactmcodigosinfo.rsteva_18, rsteva_19: @contratosactmcodigosinfo.rsteva_19, rsteva_20: @contratosactmcodigosinfo.rsteva_20, rsteva_21: @contratosactmcodigosinfo.rsteva_21, rsteva_22: @contratosactmcodigosinfo.rsteva_22, rsteva_23: @contratosactmcodigosinfo.rsteva_23, rsteva_24: @contratosactmcodigosinfo.rsteva_24, rsteva_25: @contratosactmcodigosinfo.rsteva_25, rsteva_26: @contratosactmcodigosinfo.rsteva_26, rsteva_27: @contratosactmcodigosinfo.rsteva_27, rsteva_28: @contratosactmcodigosinfo.rsteva_28, rsteva_29: @contratosactmcodigosinfo.rsteva_29, rsteva_2: @contratosactmcodigosinfo.rsteva_2, rsteva_30: @contratosactmcodigosinfo.rsteva_30, rsteva_31: @contratosactmcodigosinfo.rsteva_31, rsteva_32: @contratosactmcodigosinfo.rsteva_32, rsteva_33: @contratosactmcodigosinfo.rsteva_33, rsteva_34: @contratosactmcodigosinfo.rsteva_34, rsteva_35: @contratosactmcodigosinfo.rsteva_35, rsteva_36: @contratosactmcodigosinfo.rsteva_36, rsteva_37: @contratosactmcodigosinfo.rsteva_37, rsteva_38: @contratosactmcodigosinfo.rsteva_38, rsteva_39: @contratosactmcodigosinfo.rsteva_39, rsteva_3: @contratosactmcodigosinfo.rsteva_3, rsteva_40: @contratosactmcodigosinfo.rsteva_40, rsteva_41: @contratosactmcodigosinfo.rsteva_41, rsteva_42: @contratosactmcodigosinfo.rsteva_42, rsteva_43: @contratosactmcodigosinfo.rsteva_43, rsteva_44: @contratosactmcodigosinfo.rsteva_44, rsteva_45: @contratosactmcodigosinfo.rsteva_45, rsteva_46: @contratosactmcodigosinfo.rsteva_46, rsteva_47: @contratosactmcodigosinfo.rsteva_47, rsteva_48: @contratosactmcodigosinfo.rsteva_48, rsteva_49: @contratosactmcodigosinfo.rsteva_49, rsteva_4: @contratosactmcodigosinfo.rsteva_4, rsteva_50: @contratosactmcodigosinfo.rsteva_50, rsteva_51: @contratosactmcodigosinfo.rsteva_51, rsteva_52: @contratosactmcodigosinfo.rsteva_52, rsteva_5: @contratosactmcodigosinfo.rsteva_5, rsteva_6: @contratosactmcodigosinfo.rsteva_6, rsteva_7: @contratosactmcodigosinfo.rsteva_7, rsteva_8: @contratosactmcodigosinfo.rsteva_8, rsteva_9: @contratosactmcodigosinfo.rsteva_9, user_id: @contratosactmcodigosinfo.user_id } }
    assert_redirected_to contratosactmcodigosinfo_url(@contratosactmcodigosinfo)
  end

  test "should destroy contratosactmcodigosinfo" do
    assert_difference('Contratosactmcodigosinfo.count', -1) do
      delete contratosactmcodigosinfo_url(@contratosactmcodigosinfo)
    end

    assert_redirected_to contratosactmcodigosinfos_url
  end
end
