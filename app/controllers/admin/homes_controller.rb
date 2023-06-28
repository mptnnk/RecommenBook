class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    if params[:user_id]
      @user = User.find(params[:user_id])
      @reviews = Review.where(user_id: @user.id)
    else
      @reviews = Review.all
    end
    @reviews = @reviews.order(created_at: :DESC).page(params[:page]).per(10)
  end
end
