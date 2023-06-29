class Public::FavoriteBooksController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :find_favorite, only: [:update, :destroy]
  before_action :set_userinfo, only: [:index] # application_controller

  def index
    @favorite_books = FavoriteBook.where(user_id: @user.id).page(params[:page]).per(10)
  end

  def create
    @book = search_book(params[:book_id])
    @favorite_book = current_user.favorite_books.build(isbn: @book.isbn)
    if @favorite_book.save
      redirect_to book_path(@book.isbn), notice: "お気に入りの本に登録しました"
    else
      redirect_to book_path(@book.isbn)
    end
  end

  def update
    @favorite_book.recommenbook = params[:recommenbook] == "true"
    if @favorite_book.update_columns(recommenbook: @favorite_book.recommenbook)
      redirect_to request.referer, notice: "おすすめ本の登録を変更しました"
    else
      redirect_to request.referer, alert: "おすすめ本の登録変更に失敗しました"
    end
  end

  def destroy
    if @favorite_book.present? && @favorite_book.user == current_user
      @favorite_book.destroy
      redirect_to request.referer, alert: "お気に入りから削除しました"
    else
      redirect_to request.referer, alert: "お気に入り登録が見つかりませんでした"
    end
  end

  private
    def favorite_book_params
      params.require(:favorite_book).permit(:isbn, :recommenbook).merge(user_id: current_user.id)
    end

    def find_favorite
      @favorite_book = FavoriteBook.find(params[:id])
    end
end
