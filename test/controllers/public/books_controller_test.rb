require "test_helper"

class Public::BooksControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get public_books_search_url
    assert_response :success
  end
end
