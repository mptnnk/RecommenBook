class Public::HomesController < ApplicationController
  
  def top
    @user = current_user || User.new
  end

  def about
    @user = current_user || User.new
  end
  
end
