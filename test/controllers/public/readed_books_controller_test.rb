require "test_helper"

class Public::ReadedBooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_readed_books_index_url
    assert_response :success
  end
end
