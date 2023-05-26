class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    redirect_to request.referer
  end
  
  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_to request.referer
  end
  
  def followings
    @user = User.find(params[:user_id])
    @in_release_reviews = Review.where(user_id: @user.id, in_release: true).count
    @followings = @user.followings
    @followings.each do |following|
      @recommenbook = following.favorite_books.find_by(recommenbook: true)
      if @recommenbook.present?
        @book = RakutenWebService::Books::Book.search(isbn: @recommenbook.isbn).first
      end
    end
  end
  
  def followers
    @user = User.find(params[:user_id])
    @in_release_reviews = Review.where(user_id: @user.id, in_release: true).count
    @followers = @user.followers
    @followers.each do |follower|
      @recommenbook = follower.favorite_books.find_by(recommenbook: true)
      if @recommenbook.present?
        @book = RakutenWebService::Books::Book.search(isbn: @recommenbook.isbn).first
      end
    end
  end
  
end
