class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_userinfo, only: [:followings, :followers] # apprication_controller
  
  def create
    user = User.find_by(name: params[:user_name])
    current_user.follow(user)
    redirect_to request.referer
  end
  
  def destroy
    user = User.find_by(name: params[:user_name])
    current_user.unfollow(user)
    redirect_to request.referer
  end
  
  def followings
    @followings = @user.followings
    users_recommenbook(@followings)
  end
  
  def followers
    @followers = @user.followers
    users_recommenbook(@followers)
  end
  
  private
  
  def users_recommenbook(users)
    users.each do |user|
      recommenbook = user.favorite_books.find_by(recommenbook: true)
      if recommenbook.present?
        @book = RakutenWebService::Books::Book.search(isbn: recommenbook.isbn).first
      end
    end
  end
  
end
