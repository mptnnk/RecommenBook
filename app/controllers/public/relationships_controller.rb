class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_userinfo, only: [:followings, :followers] # apprication_controller
  
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
    @followings = @user.followings
    @follow_recommenbook = users_recommenbook(@followings)
  end
  
  def followers
    @followers = @user.followers
    @follower_recommenbook = users_recommenbook(@followers)
  end
  
  private
  
  def users_recommenbook(users)
    recommenbooks = []
    users.each do |user|
      recommenbook = user.favorite_books.find_by(recommenbook: true)
      if recommenbook.present?
        @book = RakutenWebService::Books::Book.search(isbn: recommenbook.isbn, outOfStockFlag: 1).first
        recommenbooks << @book
      end
    end
    return recommenbooks
  end
  
end
