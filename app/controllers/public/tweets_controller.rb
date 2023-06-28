class Public::TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :find_tweet, only: [:show, :destroy]
  before_action :set_userinfo, only: [:index], if: -> { params[:user_name].present? } # application_controller
  
  def index
    if params[:user_name] && @user == current_user
      @context = { tweets: get_tweets(user_id: @user.id), title: "あなたのつぶやき" }
    elsif params[:user_name] && @user != current_user
      @context = { tweets: get_tweets(user_id: @user.id), title: "#{@user.name}さんのつぶやき" }
    elsif params[:book_id]
      book = search_book(params[:book_id])
      @context = { tweets: get_tweets(isbn: params[:book_id]), title: "#{book['title'].truncate(20)}のつぶやき" }
    else
      @context = { tweets: Tweet.page(params[:page]).per(10).order(created_at: :DESC), title: 'つぶやき' }
    end
  end

  def show
    @comments = @tweet.tweet_comments.order(created_at: :DESC).page(params[:page]).per(10)
    if @tweet.isbn.present?
      @book = search_book(@tweet.isbn)
      @book_favorites = book_favorites(@book.isbn)
    end
    @tweet_comment = TweetComment.new
  end

  def new
    if params[:book_id].present?
      @book = search_book(params[:book_id])
      @book_isbn = @book["isbn"]
      @book_favorites = book_favorites(@book.isbn)
      @tweet = Tweet.new
    else
      @tweet = Tweet.new
    end
  end  

  def create
    if params[:book_id].present?
      @book = search_book(params[:book_id])
      @book_favorites = book_favorites(@book.isbn)
      @tweet = current_user.tweets.build(
        isbn: @book.isbn,
        tweet_content: params[:tweet][:tweet_content]
      )
      if @tweet.save
        redirect_to book_path(@book.isbn), notice: "つぶやきを投稿しました"
      else
        flash.now[:alert] = "つぶやきを投稿できませんでした"
        render :new
      end

    else
      @tweet = current_user.tweets.build(tweet_content: params[:tweet][:tweet_content])
      if @tweet.save
        redirect_to tweets_path, notice: "つぶやきを投稿しました"
      else
        render :new
      end
    end
  end
  
  def destroy
    if @tweet.user == current_user && @tweet.destroy
      if request.referer&.match(/\/tweets\/\d+/)
        redirect_to tweets_path, alert: 'つぶやきを削除しました'
      else
        redirect_to request.referer, alert: 'つぶやきを削除しました'
      end
    else
      redirect_to request.referer, alert: '削除できませんでした'
    end
  end
  
  private
  
  def tweet_params
    params.require(:tweet).permit(:isbn, :tweet_content).merge(user_id:current_user.id)
  end
  
  def get_tweets(condition)
    Tweet.where(condition).page(params[:page]).per(10).order(created_at: :DESC)
  end
  
  def find_tweet
    @tweet = Tweet.find(params[:id])
  end
  
  def book_favorites(isbn)
    FavoriteBook.where(isbn: @book.isbn)
  end
  
end
