class Admin::TweetsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @tweets = Tweet.all.order(created_at: :DESC).page(params[:page]).per(10)
  end

  def show
    @tweet - Tweet.find(params[:id])
  end
  
  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy
    redirect_to admin_tweets_path, alert: "ツイートを削除しました"
  end
end
