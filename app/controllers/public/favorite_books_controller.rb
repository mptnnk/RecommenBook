class Public::FavoriteBooksController < ApplicationController
  before_action: authenticate_user!
  
  def create
    @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
    @book_isbn = @book["isbn"]
    @favorite_book = current_user.favorite_books.build(favorite_book_params)
  end

  def index
  end
  
  def destroy
  end
  
  private
  
  def favorite_book_params
    params.require(:favorite_book).permit(:isbn).mergh(user_id :current_user.id)
  end
end