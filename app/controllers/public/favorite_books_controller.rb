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
    @recommenbook = @user.favorite_books.find_by(recommenbook: true)
    if @recommenbook.present?
      @book = RakutenWebService::Books::Book.search(isbn: @recommenbook.isbn).first
    end
  end
  
  def update
    @favorite_book = FavoriteBook.find(params[:id])
    @favorite_book.recommenbook = params[:recommenbook] == "true"
    if @favorite_book.update_columns(recommenbook: @favorite_book.recommenbook)
      redirect_to request.referer, notice: 'おすすめの本を登録しました'
    end
  end

  def destroy
    @favorite_book = FavoriteBook.find(params[:id])
    # @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
    # @favorite_book = current_user.favorite_books.find_by(isbn: @book.isbn)
    if @favorite_book.destroy
      redirect_to request.referer, alert: 'お気に入りから削除しました'
    end
  end
  
  private
  
  def favorite_book_params
    params.require(:favorite_book).permit(:isbn, :recommenbook).merge(user_id :current_user.id)
  end
end