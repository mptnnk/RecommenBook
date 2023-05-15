require "test_helper"

class Public::FavoriteBooksControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_favorite_books_create_url
    assert_response :success
  end

  test "should get index" do
    get public_favorite_books_index_url
    assert_response :success
  end
end
