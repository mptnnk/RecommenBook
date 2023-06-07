class Admin::ReviewsController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_review, only: [:show, :update]
  
  def show
    @book = search_book(@review.isbn)
    @book_favorites = FavoriteBook.where(isbn: @book.isbn)
  end
  
  def update
    @review.update(review_params) ? (redirect_to admin_review_path(@review), notice: 'レビューのステータスを更新しました') : (render :show, alert: 'レビューのステータス更新に失敗しました')
  end
  
  private
  
  def review_params
    params.require(:review).permit(:in_release, :spoiler)
  end
  
  def find_review
    @review = Review.find(params[:id])
  end
    
end
