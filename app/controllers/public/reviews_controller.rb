class Public::ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :destroy, :delete_readed]
  before_action :find_review, only: [:show, :edit, :update,:destroy]
  before_action :set_userinfo, only: [:index, :readed_list], if: -> { params[:user_name].present? } # application_controller
  
  def index
    if params[:user_name]
      if @user == current_user
        @my_reviews = get_reviews(user_id: current_user.id)
      elsif @user != current_user
        @user_reviews = get_reviews(user_id: @user.id, in_release: true)
      end
    elsif params[:book_id]
      @book = search_book(params[:book_id])
      @book_reviews = get_reviews(isbn: params[:book_id], in_release: true)
    elsif params[:user_name].blank? && params[:book_id].blank?
      @reviews = get_reviews(in_release: true)
    end
  end
  
  def readed_list
    @user = User.find_by(name: params[:user_name])
    if @user == current_user
      @readed_lists = readed_lists(current_user.id)
    elsif @user != current_user
      @readed_lists = readed_lists(@user.id)
    end
  end
  
  def delete_readed
    readed = Review.find(params[:readed_id])
    readed.destroy
    flash[:alert] = "読んだ本を削除しました"
    redirect_to readed_list_path(user_name: current_user.name)
  end

  def show
    @book = search_book(@review.isbn)
    @book_favorites = book_favorites(@book.isbn)
    @review_comment = ReviewComment.new
    @comments = @review.review_comments.order(created_at: :DESC).page(params[:page]).per(10)
  end

  def new
    @book = search_book(params[:book_id])
    @readed = Review.where(user_id: current_user.id,isbn: @book.isbn)
    @book_favorites = book_favorites(@book.isbn)
    @review = Review.new
  end  

  def create
    @book = search_book(params[:book_id])
    @review = Review.new(review_params)
    @review.save ? (redirect_to book_path(@book.isbn), notice: '登録しました') : (render :new)
  end
  
  def edit
    @book = search_book(@review.isbn)
    @book_favorites = book_favorites(@book.isbn)
  end
  
  def update
    @book = search_book(@review.isbn)
    @review.update(review_params) ? (redirect_to book_path(@book.isbn), notice: '更新しました') : (render :edit)
  end
  
  def destroy
    if @review.destroy
      if request.referer&.match(/\/reviews\/\d+/)
        redirect_to reviews_path, alert: 'レビューを削除しました'
      elsif request.referer&.match(/\/reviews\/\d+\/edit/)
        redirect_to reviews_path, alert: 'レビューを削除しました'
      else
        redirect_to request.referer, alert: 'レビューを削除しました'
      end
    else
      redirect_to request.referer, alert: '削除できませんでした'
    end
  end
  
  private
  
  def review_params
    params.require(:review).permit(:isbn, :content, :readed_at, :in_release, :spoiler, :rate).merge(user_id:current_user.id)
  end
  
  def find_review
    @review = Review.find(params[:id])
  end
  
  def get_reviews(condition)
    Review.where(condition).where.not(content: [nil, '']).page(params[:page]).per(10)
  end
  
  def book_favorites(isbn)
    FavoriteBook.where(isbn: @book.isbn)
  end
  
  def readed_lists(user_id)
    find_readed_review = Review.where(user_id: user_id).group_by(&:isbn).transform_values { |v| v.max_by { |review| review.readed_at || Time.at(0) } }.values.sort_by { |review| review.created_at }.reverse
    Kaminari.paginate_array(find_readed_review).page(params[:page]).per(10)
  end
  
end
