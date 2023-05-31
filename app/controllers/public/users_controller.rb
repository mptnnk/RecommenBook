class Public::UsersController < ApplicationController
  # before_action :authenticate_user!, only: [:edit, :update, :unsubscribe]
  before_action :set_current_user, only: [:edit, :update, :unsubscribe, :withdraw]
  before_action :set_userinfo, only: [:show, :favorite_genres]

  def show
    redirect_to root_path, alert: 'It is Unsubscribed Users'  unless @user
  end
  
  def favorite_genres
  end

  def edit
  end
  
  def update
    @user.update(user_params) ? (redirect_to mypage_path(@user), notice: '会員情報を更新しました') : (render :edit)
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
    params.require(:user).permit(:name, :email, :is_active, :password, :profile_image, genre_ids: [] )
  end
  
  def set_current_user
    @user = current_user
    redirect_to root_path if @user.nil?
  end

end