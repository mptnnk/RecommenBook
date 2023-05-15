class Public::FavoriteBooksController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
    @book_isbn = @book["isbn"]
    if current_user.favorite_books.exists?(isbn: @book.isbn)
      redirect_to request.referer, alert: 'すでにお気に入りに登録済みの本です'
    else
      @favorite_book = current_user.favorite_books.build(isbn: @book.isbn)
      if @favorite_book.save
        redirect_to book_path(@book.isbn), notice: 'お気に入りの本に登録しました'
      end
    end
  end
  
  def index
    user_id = params[:user_id]
    @user = User.find(user_id)
    @favorite_books = FavoriteBook.where(user_id: @user.id)
  end

  def destroy
    @book = RakutenWebService::Books::Book.search(isbn: params[book_id]).first
    @book_isbn = @book["isbn"]
  end
  
  private
  
  def favorite_book_params
    params.require(:favorite_book).permit(:isbn).merge(user_id :current_user.id)
  end
end