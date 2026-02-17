require 'test_helper'

class EproveedorescimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eproveedorescimagen = eproveedorescimagenes(:one)
  end

  test "should get index" do
    get eproveedorescimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_eproveedorescimagen_url
    assert_response :success
  end

  test "should create eproveedorescimagen" do
    assert_difference('Eproveedorescimagen.count') do
      post eproveedorescimagenes_url, params: { eproveedorescimagen: { compraimagen: @eproveedorescimagen.compraimagen, eproveedorescompra_id: @eproveedorescimagen.eproveedorescompra_id, user_id: @eproveedorescimagen.user_id } }
    end

    assert_redirected_to eproveedorescimagen_url(Eproveedorescimagen.last)
  end

  test "should show eproveedorescimagen" do
    get eproveedorescimagen_url(@eproveedorescimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_eproveedorescimagen_url(@eproveedorescimagen)
    assert_response :success
  end

  test "should update eproveedorescimagen" do
    patch eproveedorescimagen_url(@eproveedorescimagen), params: { eproveedorescimagen: { compraimagen: @eproveedorescimagen.compraimagen, eproveedorescompra_id: @eproveedorescimagen.eproveedorescompra_id, user_id: @eproveedorescimagen.user_id } }
    assert_redirected_to eproveedorescimagen_url(@eproveedorescimagen)
  end

  test "should destroy eproveedorescimagen" do
    assert_difference('Eproveedorescimagen.count', -1) do
      delete eproveedorescimagen_url(@eproveedorescimagen)
    end

    assert_redirected_to eproveedorescimagenes_url
  end
end
