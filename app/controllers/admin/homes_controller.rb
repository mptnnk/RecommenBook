class Admin::HomesController < ApplicationController
  
  def top
    @reviews = Review.all.order(created_at: :DESC).page(params[:page]).per(10)
  end

end
