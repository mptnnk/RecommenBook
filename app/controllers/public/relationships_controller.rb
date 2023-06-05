class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_userinfo, only: [:followings, :followers]
  
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
    @followings = @user.followings.where(is_active: true).page(params[:page]).per(10)
  end
  
  def followers
    @followers = @user.followers.where(is_active: true).page(params[:page]).per(10)
  end
    
end
  
