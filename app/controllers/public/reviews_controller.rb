class Public::ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :destroy]
  before_action :submitted_review, only: [:show, :edit, :update, :destroy]
  # before_action :book_isbn, only: [:new, :create, :edit, :destroy]
  
  def new
    @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
    @book_isbn = @book["isbn"]
    @book_favorites = FavoriteBook.where(isbn: @book.isbn)
    @review = Review.new
    @readed_book = current_user.readed_books.find_by(isbn: @book.isbn)
  end
  
  def create
    @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
    @review = Review.new(review_params)
    if @review.save!
      redirect_to book_path(@book.isbn), notice: 'レビューが投稿されました'
    else
      render :new
    end
  end

  def index
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      if @user == current_user
        @my_reviews = Review.where(user_id: current_user.id).page(params[:page]).per(10).order(created_at: :DESC)
      elsif @user != current_user
        @user_reviews = Review.where(user_id: @user.id).where(in_release: true).page(params[:page]).per(10).order(created_at: :DESC)
      end
    elsif params[:user_id].blank?
      @reviews = Review.page(params[:page]).where(in_release: true).per(10).order(created_at: :DESC)
    end
  end

  def show
    @book = RakutenWebService::Books::Book.search(isbn: @review.isbn).first
    @book_favorites = FavoriteBook.where(isbn: @book.isbn)
    @review_comment = ReviewComment.new
  end
  
  def hashtag

  end

  def edit
    @book = RakutenWebService::Books::Book.search(isbn: @review.isbn).first
    @book_favorites = FavoriteBook.where(isbn: @book.isbn)
  end
  
  def update
    @book = RakutenWebService::Books::Book.search(isbn: @review.isbn).first
    if @review.update(review_params)
      flash[:notice] = "レビュー内容を更新しました"
      redirect_to book_path(@book.isbn)
    else
      render :edit
    end
  end
  
  def destroy
    @review.destroy if @review
    @book = RakutenWebService::Books::Book.search(isbn: @review.isbn).first
    if request.referer == review_path(@review)
      redirect_to reviews_path, alert: 'レビューを削除しました'
    else
      redirect_to request.referer, alert: 'レビューを削除しました'
    end
  end
  
  private
  
  def review_params
    params.require(:review).permit(:isbn, :content, :readed_at, :in_release, :spoiler).merge(user_id:current_user.id)
  end
  
  def submitted_review
    @review = Review.find(params[:id])
  end
  
  # def book_isbn
  #   @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
  #   @book_isbn = @book["isbn"]
  # end

end
