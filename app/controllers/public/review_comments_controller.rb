class Public::ReviewCommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  
  def index
    @user = User.find(params[:user_id])
    @in_release_reviews = Review.where(user_id: @user.id, in_release: true).count
    @recommenbook = @user.favorite_books.find_by(recommenbook: true)
    if @recommenbook.present?
      @book = RakutenWebService::Books::Book.search(isbn: @recommenbook.isbn).first
    end
    @review_comments = ReviewComment.where(user_id: @user.id)
    @review_comments.each do |comment|
      @review = comment.review
    end
    @tweet_comments = TweetComment.where(user_id: @user.id)
    @tweet_comments.each do |comment|
      @tweet = comment.tweet
    end
    @comments = @review_comments + @tweet_comments
    @comments = @comments.sort_by { |comment| comment.created_at }.reverse
  end

  def create
    review = Review.find(params[:review_id])
    @comment = current_user.review_comments.new(review_comment_params)
    @comment.review_id = review.id
    @comment.save
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
