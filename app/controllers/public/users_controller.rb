class Public::UsersController < ApplicationController
  # before_action :authenticate_user!, only: [:edit, :update, :unsubscribe]
  before_action :set_current_user, only: [:edit, :update, :unsubscribe, :withdraw]
  before_action :set_userinfo, only: [:show, :profile, :favorite_genres]

  def show
    redirect_to root_path, alert: '有効ではないユーザーです'  unless @user

  end
  
  def profile
  end
  
  def favorite_genres
  end

  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to mypage_path(@user), notice: "ユーザー情報を更新しました"
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit
    end
  end

  def unsubscribe
  end
  
  def withdraw
    @user.update(is_active: false)
    reset_session
    redirect_to root_path, notice: '退会処理が完了しました'
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :is_active, :password, :profile_image, :introduction, genre_ids: [] )
  end
  
  def set_current_user
    @user = current_user
    redirect_to root_path if @user.nil?
  end

end