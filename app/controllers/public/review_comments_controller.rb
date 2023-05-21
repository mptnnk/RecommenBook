class Public::ReviewCommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  
  def create
    review = Review.find(params[:review_id])
    @comment = current_user.review_comments.new(review_comment_params)
    @comment.review_id = review.id
    @comment.save
  end
  
  def index
    @user = User.find(params[:user_id])
    @review_comments = ReviewComment.where(user_id: @user.id)
    @tweet_comments = TweetComment.where(user_id: @user.id)
    @comments = @review_comments + @tweet_comments
    @comments = @comments.sort_by { |comment| comment.created_at }.reverse
  end
  
  def destroy
    @comment = ReviewComment.find(params[:id])
    @comment.destroy
  end
  
  private
  
  def review_comment_params
    params.require(:review_comment).permit(:comment)
  end
  
end
