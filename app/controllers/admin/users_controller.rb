class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @users = User.all.order(created_at: :DESC).page(params[:page]).per(10)
  end
  
  def edit
  end
  
  def update
  end
  
  private
  
  def user_params
  end
  
end
