class Public::HashtagsController < ApplicationController
  def index
    @user = current_user
    @tag = Hashtag.find_by(name: params[:name])
    @reviews = @tag.reviews
    @tweets = @tag.tweets
  end
end
