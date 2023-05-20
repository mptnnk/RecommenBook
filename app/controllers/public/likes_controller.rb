class Public::LikesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    if params[:review_id]
      review = Review.find(params[:review_id])
      @review_like = current_user.likes.new(review_id: review.id)
      @review_like.save
      p @review_like.errors.full_messages
      render 'review_replace_btn'
    elsif params[:tweet_id]
      tweet = Tweet.find(params[:tweet_id])
      @tweet_like = current_user.likes.new(tweet_id: tweet.id)
      @tweet_like.save
      render 'tweet_replace_btn'
    end
  end
  
  def destroy
    if params[:review_id]
      review = Review.find(params[:review_id])
      @review_like = current_user.likes.find_by(review_id: review.id)
      @review_like.destroy
      render 'review_replace_btn'
    elsif params[:tweet_id]
      tweet = Tweet.find(params[:tweet_id])
      @tweet_like = current_user.likes.find_by(tweet_id: tweet.id)
      @tweet_like.destroy
      render 'tweet_replace_btn'
    end
  end
  
end
