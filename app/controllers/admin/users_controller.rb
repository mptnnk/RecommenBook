class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only: [:edit, :update]
  
  def index
    @users = User.all.order(created_at: :DESC).page(params[:page]).per(10)
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'ユーザー情報を変更しました'
    else
      flash.now[:alert] = 'ユーザー情報の更新に失敗しました'
      render :edit
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :is_active)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
end
