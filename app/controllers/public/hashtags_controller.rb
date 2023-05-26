class Public::HashtagsController < ApplicationController
  def index
    @tag = Hashtag.find_by(name: params[:name])
    # @tag = Hashtag.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%").first
    @reviews = @tag.reviews.order(created_at: :desc)
    @tweets = @tag.tweets.order(created_at: :desc)
    @posts = (@reviews + @tweets).uniq.sort_by(&:created_at).reverse
    @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(10)
  end
end
