class Admin::TweetsController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_tweet, only: [:show, :destroy]

  def index
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @tweets = Tweet.where(user_id: params[:user_id]).order(created_at: :DESC).page(params[:page]).per(10)
    else
      @tweets = Tweet.all.order(created_at: :DESC).page(params[:page]).per(10)
    end
  end

  def show
    if @tweet.isbn.present?
      @book = search_book(@tweet.isbn)
      @book_favorites = FavoriteBook.where(isbn: @book.isbn)
    end
  end

  def destroy
    @tweet.destroy
    redirect_to admin_tweets_path, alert: "つぶやきを削除しました"
  end

  private
    def find_tweet
      @tweet = Tweet.find(params[:id])
    end
end
