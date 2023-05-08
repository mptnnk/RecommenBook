class Public::UserController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :unsubscribe]
  before_action :set_current_user
  
  def index
    
  end

  def show
    @user = User.find_by(name: params[:id])
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
    params.require(:user).permit(:book_id, :name, :email, :is_deleted, :profile_image)
  end
  
  def set_current_user
    @user = current_user
  end

end