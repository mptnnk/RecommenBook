class Public::FavoriteBooksController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  
  def create
    @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
    @favorite_book = current_user.favorite_books.build(isbn: @book.isbn)
    if @favorite_book.save
      redirect_to book_path(@book.isbn), notice: 'お気に入りの本に登録しました'
    end
  end
  
  def index
    user_id = params[:user_id]
    @user = User.find(user_id)
    @favorite_books = FavoriteBook.where(user_id: @user.id).page(params[:page]).per(10)
  end
  
  def update
  end

  def destroy
    @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
    @favorite_book = current_user.favorite_books.find_by(isbn: @book.isbn)
    if @favorite_book.destroy
      redirect_to request.referer, alert: 'お気に入りから削除しました'
    end
  end
  
  private
  
  def favorite_book_params
    params.require(:favorite_book).permit(:isbn).merge(user_id :current_user.id)
  end
end