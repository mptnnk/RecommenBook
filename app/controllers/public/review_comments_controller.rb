class Public::ReviewCommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_userinfo, only: [:index] # application_controller
  
  def index
    @review_comments = ReviewComment.where(user_id: @user.id)
    @review_comments.each do |comment|
      @review = comment.review
    end
    @tweet_comments = TweetComment.where(user_id: @user.id)
    @tweet_comments.each do |comment|
      @tweet = comment.tweet
    end
    comment_sum = @review_comments + @tweet_comments
    comment_sum = comment_sum.sort_by { |comment| comment.created_at }.reverse
    @comments = Kaminari.paginate_array(comment_sum).page(params[:page]).per(10)

  end

  def create
    review = Review.find(params[:review_id])
    @comment = current_user.review_comments.new(review_comment_params)
    @comment.review_id = review.id
    @comment.save
    @comments = review.review_comments.all
  end
  
  def destroy
    review = Review.find(params[:review_id])
    @comment = ReviewComment.find(params[:id])
    @comment.destroy
    @comments = review.review_comments.all
  end
  
  private
  
  def review_comment_params
    params.require(:review_comment).permit(:comment)
  end
  
end
