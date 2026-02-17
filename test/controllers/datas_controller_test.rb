require 'test_helper'

class DatasControllerTest < ActionDispatch::IntegrationTest
  test "should get informe" do
    get datas_informe_url
    assert_response :success
  end

end
