require "test_helper"

class Admin::TweetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_tweets_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_tweets_show_url
    assert_response :success
  end
end
