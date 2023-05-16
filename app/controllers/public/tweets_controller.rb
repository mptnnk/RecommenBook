class Public::TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  
  def new
    @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
    @book_isbn = @book["isbn"]
    @tweet = Tweet.new
  end
  
  def create
    @book = RakutenWebService::Books::Book.search(isbn: params[:tweet][:isbn]).first
    if @book.present?
      @tweet = Tweet.new(
        isbn: @book.isbn,
        tweet_content: params[:tweet_content]
      )
    else
      @tweet = Tweet.new(tweet_content: params[:tweet_content])
    end
    if @tweet.save!
      redirect_to book_path(@book.isbn), notice: "つぶやきを投稿しました"
    else
      render :new
    end
  end

  def index
  end

  def show
  end
  
  def destroy
  end
  
  private
  
  def tweet_params
    params.require(:tweet).permit(:isbn, :tweet_content).merge(user_id:current_user.id)
  end
  
end
