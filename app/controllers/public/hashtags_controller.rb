class Public::HashtagsController < ApplicationController
  def index
    @tag = Hashtag.find_by(name: params[:name])
    @reviews = @tag.reviews.order(created_at: :desc)
    @tweets = @tag.tweets.order(created_at: :desc)
    @posts = (@reviews + @tweets).sort_by(&:created_at).reverse
  end
end
