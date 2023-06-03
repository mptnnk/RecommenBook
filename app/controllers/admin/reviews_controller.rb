class Admin::ReviewsController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    @review = Review.find(params[:id])
    @book = RakutenWebService::Books::Book.search(isbn: @review.isbn, outOfStockFlag: 1).first
    @book_favorites = FavoriteBook.where(isbn: @book.isbn)
  end
  
  def update
    @review = Review.find(params[:id])
    @review.update(review_params) ? (redirect_to admin_review_path(@review), notice: 'レビューのステータスを更新しました') : (render :show, alert: 'レビューのステータス更新に失敗しました')
  end
  
  private
  
  def review_params
    params.require(:review).permit(:in_release, :spoiler)
  end
    
end
