require "test_helper"

class Public::HashtagsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_hashtags_index_url
    assert_response :success
  end
end
