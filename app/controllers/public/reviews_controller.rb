class Public::ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :destroy]
  before_action :submitted_review, only: [:show, :edit, :update, :destroy]
  before_action :set_userinfo, only: [:index], if: -> { params[:user_name].present? } # application_controller
  
  def index
    if params[:user_name]
      if @user == current_user
        @my_reviews = Review.where(user_id: current_user.id).page(params[:page]).per(10).order(created_at: :DESC)
      elsif @user != current_user
        @user_reviews = Review.where(user_id: @user.id).where(in_release: true).page(params[:page]).per(10).order(created_at: :DESC)
      end
      
    elsif params[:book_id]
      @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
      @book_reviews = Review.where(isbn: params[:book_id]).page(params[:page]).per(10).order(created_at: :DESC)
      
    elsif params[:user_name].blank? && params[:book_id].blank?
      @reviews = Review.where(in_release: true).page(params[:page]).per(10).order(created_at: :DESC)
      # @reviews = Review.joins(:user).where(in_release : true, users: {is_active: true}).page(params[:page]).per(10).order(created_at: :DESC)
    end
  end

  def show
    @book = RakutenWebService::Books::Book.search(isbn: @review.isbn).first
    @book_favorites = FavoriteBook.where(isbn: @book.isbn)
    @review_comment = ReviewComment.new
    @comments = @review.review_comments.all
  end

  def new
    @book = find_book(params[:book_id])
    @book_isbn = @book["isbn"]
    @book_favorites = FavoriteBook.where(isbn: @book.isbn)
    @review = Review.new
    @readed_book = current_user.readed_books.find_by(isbn: @book.isbn)
  end  

  def edit
    @book = find_book(@review.isbn)
    @book_favorites = FavoriteBook.where(isbn: @book.isbn)
  end

  def create
    @book = find_book(params[:book_id])
    @review = Review.new(review_params)
    @review.save ? (redirect_to book_path(@book.isbn), notice: 'レビューが投稿されました') : (render :new)
  end
  
  def update
    @book = find_book(@review.isbn)
    @review.update(review_params) ? (redirect_to book_path(@book.isbn), notice: 'レビュー内容を更新しました') : (render :edit)
  end
  
  def destroy
    if @review.destroy
      if request.referer == review_url(@review)
        redirect_to reviews_path, alert: 'レビューを削除しました'
      else
        redirect_to request.referer, alert: 'レビューを削除しました'
      end
    else
      redirect_to request.referer, alert: '削除に失敗しました'
    end
  end
  
  private
  
  def review_params
    params.require(:review).permit(:isbn, :content, :readed_at, :in_release, :spoiler).merge(user_id:current_user.id)
  end
  
  def submitted_review
    @review = Review.find(params[:id])
  end
  
  def find_book(isbn)
    RakutenWebService::Books::Book.search(isbn: isbn).first
  end

end
