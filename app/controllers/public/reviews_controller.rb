class Public::ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :destroy]
  before_action :submitted_review, only: [:show, :edit, :update, :destroy]
  before_action :set_userinfo, only: [:index, :readed_list], if: -> { params[:user_name].present? } # application_controller
  
  def index
    if params[:user_name]
      if @user == current_user
        @my_reviews = Review.where(user_id: current_user.id).where.not(content: [nil, '']).page(params[:page]).per(10).order(created_at: :DESC)
      elsif @user != current_user
        @user_reviews = Review.where(user_id: @user.id, in_release: true).where.not(content: [nil, '']).page(params[:page]).per(10).order(created_at: :DESC)
      end
      
    elsif params[:book_id]
      @book = RakutenWebService::Books::Book.search(isbn: params[:book_id], outOfStockFlag: 1).first
      @book_reviews = Review.where(isbn: params[:book_id], in_release: true).where.not(content: [nil, '']).page(params[:page]).per(10).order(created_at: :DESC)
      
    elsif params[:user_name].blank? && params[:book_id].blank?
      @reviews = Review.where(in_release: true).where.not(content: [nil, '']).page(params[:page]).per(10).order(created_at: :DESC)
    end
  end
  
  def readed_list
    @user = User.find_by(name: params[:user_name])
    if @user == current_user
      @readed_lists = Review.where(user_id: current_user.id).select("isbn, MAX(readed_at) as latest_readed_at").group(:isbn)
    elsif @user != current_user
      @readed_lists = Review.where(user_id: @user.id).select("isbn, MAX(readed_at) as latest_readed_at").group(:isbn)
    end
  end

  def show
    @book = RakutenWebService::Books::Book.search(isbn: @review.isbn, outOfStockFlag: 1).first
    @book_favorites = FavoriteBook.where(isbn: @book.isbn)
    @review_comment = ReviewComment.new
    @comments = @review.review_comments.all
  end

  def new
    @book = find_book(params[:book_id])
    @readed = Review.where(user_id: current_user.id,isbn: @book.isbn)
    @book_favorites = FavoriteBook.where(isbn: @book.isbn)
    @review = Review.new
  end  

  def edit
    @book = find_book(@review.isbn)
    @book_favorites = FavoriteBook.where(isbn: @book.isbn)
  end

  def create
    @book = find_book(params[:book_id])
    @review = Review.new(review_params)
    @review.save ? (redirect_to book_path(@book.isbn), notice: '登録しました！') : (render :new)
  end
  
  def update
    @book = find_book(@review.isbn)
    @review.update(review_params) ? (redirect_to book_path(@book.isbn), notice: '更新しました！') : (render :edit)
  end
  
  def destroy
    if @review.destroy
      if request.referer == review_url(@review)
        redirect_to reviews_path, alert: 'レビューを消しました'
      else
        redirect_to request.referer, alert: 'レビューを消しました'
      end
    else
      redirect_to request.referer, alert: 'レビューを消せませんでした ;('
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
    RakutenWebService::Books::Book.search(isbn: isbn, outOfStockFlag: 1).first
  end

end
