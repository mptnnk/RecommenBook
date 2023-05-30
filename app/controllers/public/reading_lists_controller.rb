class Public::ReadingListsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_userinfo, only: [:index] # application_controller
  
  def index
    @reading_lists = ReadingList.where(user_id: @user.id)
  end

  def create
    @book = RakutenWebService::Books::Book.search(isbn: params[:book_id], outOfStockFlag: 1).first
    @book_isbn = @book['isbn']
    @readed_book = current_user.readed_books.build(
      isbn: @book.isbn,
      readed_at: params[:readed_at]
    )
    if @readed_book.save
      redirect_to book_path(@book.isbn), notice: '読んだ本に登録しました'
    end
  end  
  
  def destroy
    @book = RakutenWebService::Books::Book.search(isbn: params[:book_id], outOfStockFlag: 1).first
    @readed_book = current_user.readed_books.find_by(isbn: @book.isbn)
    if @readed_book.destroy
      redirect_to request.referer, alert: '読んだ本から削除しました'
    end
  end
  
  private
  
  def readed_book_params
    params.require(:readed_book).permit(:isbn, :readed_at).merge(user_id :current_user.id)
  end

end