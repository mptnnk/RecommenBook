class Admin::TweetsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    if params[:user_id].present?
      @tweets = Tweet.where(user_id: params[:user_id]).order(created_at: :DESC).page(params[:page]).per(10)
    else
      @tweets = Tweet.all.order(created_at: :DESC).page(params[:page]).per(10)
    end
  end

  def show
    @tweet = Tweet.find(params[:id])
  end
  
  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy
    redirect_to admin_tweets_path, alert: "ツイートを削除しました"
  end
end
