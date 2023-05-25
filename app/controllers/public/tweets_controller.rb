class Public::TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  
  def new
    if params[:book_id].present?
      @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
      @book_isbn = @book["isbn"]
      @book_favorites = FavoriteBook.where(isbn: @book.isbn)
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
        redirect_to tweets_path, notice: "つぶやきを投稿しました"
      else
        render :new
      end
    end
  end

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @tweets = Tweet.where(user_id: @user.id).page(params[:page]).per(10).order(created_at: :DESC)
    else
      @tweets = Tweet.page(params[:page]).per(10).order(created_at: :DESC)
    end
  end

  def show
    @tweet = Tweet.find(params[:id])
    @comments = @tweet.tweet_comments.all
    if @tweet.isbn.present?
      @book = RakutenWebService::Books::Book.search(isbn: @tweet.isbn).first
      @book_favorites = FavoriteBook.where(isbn: @book.isbn)
    end
    @tweet_comment = TweetComment.new
  end
  
  def destroy
    @tweet = Tweet.find(params[:id])
    if @tweet.destroy
      redirect_to tweets_path, alert: 'つぶやきを削除しました'
    end
  end
  
  private
  
  def tweet_params
    params.require(:tweet).permit(:isbn, :tweet_content).merge(user_id:current_user.id)
  end
  
end
