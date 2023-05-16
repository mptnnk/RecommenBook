class Public::TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  
  def new
    if params[:book_id].present?
      @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
      @book_isbn = @book["isbn"]
      @tweet = Tweet.new
    else
      @tweet = Tweet.new
    end
  end
  
  def create
    if params[:book_id].present?
      @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
      @tweet = current_user.tweets.build(
        isbn: @book.isbn,
        tweet_content: params[:tweet][:tweet_content]
      )
      if @tweet.save!
        redirect_to book_path(@book.isbn), notice: "つぶやきを投稿しました"
      else
        render :new
      end
    else
      @tweet = current_user.tweets.build(tweet_content: params[:tweet][:tweet_content])
      if @tweet.save!
        redirect_to tweet_path, notice: "つぶやきを投稿しました"
      else
        render :new
      end
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
