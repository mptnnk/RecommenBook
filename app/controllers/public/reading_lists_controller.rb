class Public::ReadingListsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_userinfo, only: [:index] # application_controller

  def index
    @reading_lists = ReadingList.where(user_id: @user.id).page(params[:page]).order(created_at: :DESC).per(10)
  end

  def create
    @book = search_book(params[:book_id])
    @reading_list = current_user.reading_lists.build(isbn: @book.isbn)
    @reading_list.save ? (redirect_to book_path(@book.isbn), notice: "読みたい本に登録しました") : (redirect_to request.referer, alert: "登録に失敗しました")
  end

  def destroy
    @book = search_book(params[:book_id])
    @reading_list = current_user.reading_lists.find_by(isbn: @book.isbn)
    @reading_list.destroy ? (redirect_to request.referer, alert: "読みたい本から削除しました") : (redirect_to request.referer, alert: "削除できませんでした")
  end

  private
    def reading_book_params
      params.require(:reading_book).permit(:isbn).merge(user_id :current_user.id)
    end
end
