class Public::ReviewsController < ApplicationController
  def new
    @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
    @book_isbn = @book["isbn"]
    @review = Review.new
  end
  
  def create
    @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
    @review = Review.new(review_params)
    # @review.book_title = @book.title
    # @review.book_author = @book.author
    
    if @review.save!
      redirect_to book_path(@book.isbn), notice: 'レビューが投稿されました'
    else
      render :new
    end
  end

  def index
    @reviews = Review.all
  end

  def show
  end

  def edit
  end
  
  private
  
  def review_params
    params.require(:review).permit(:isbn, :content, :readed_at, :in_release).merge(user_id:current_user.id)
  end
  
end
