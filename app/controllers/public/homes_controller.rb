class Public::HomesController < ApplicationController
  
  def top
    @user = User.new
  end
  
  def index
    @user = User.new
  end

  def about
    @user = User.new
  end
end
