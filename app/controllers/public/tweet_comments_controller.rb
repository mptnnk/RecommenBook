class Public::TweetCommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :find_tweet, only: [:create, :destroy]
  
  def create
    @comment = current_user.tweet_comments.new(tweet_comment_params)
    @comment.tweet_id = @tweet.id
    @comment.save
    @comments = @tweet.tweet_comments.all
  end
  
  def destroy
    @comment = TweetComment.find(params[:id])
    @comment.destroy
    @comments = @tweet.tweet_comments.all
  end
  
  private
  
  def tweet_comment_params
    params.require(:tweet_comment).permit(:comment)
  end
  
  def find_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end
  
end
