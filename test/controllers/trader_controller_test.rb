require "test_helper"

class TraderControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get trader_index_url
    assert_response :success
  end
end
