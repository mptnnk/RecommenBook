class Public::LikesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    review = Review.find(params[:review_id])
    tweet = Tweet.find(params[:tweet_id])
    @review_like = current_user.likes.new(review_id: review.id)
    @tweet_like = current_user.likes.new(tweet_id: tweet.id)
    if @review_like.save
      render 'review_replace_btn'
    else @tweet_like.save
      render 'tweet_replace_btn'
    end
  end
  
  def destroy
  end
  
end
