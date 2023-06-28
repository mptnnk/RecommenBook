class Public::HomesController < ApplicationController
  before_action :set_userinfo

  def top
    @user = current_user || User.new
  end

  def about
    @user = current_user || User.new
  end

  def search
    @model = params["search"]["model"]
    @keyword = params["search"]["keyword"]
    @results = search_for(@model, @keyword)
  end

  private
    def search_for(model, keyword)
      if model == "hashtag"
        Hashtag.where("hashname LIKE ?", "%#{keyword}%")
        reviews = Review.joins(:hashtags).where("LOWER(hashtags.hashname) LIKE  ?", "%#{keyword.downcase}%").where(in_release: true)
        tweets = Tweet.joins(:hashtags).where("LOWER(hashtags.hashname) LIKE ?", "%#{keyword.downcase}%")
        posts = (reviews + tweets).uniq.sort_by(&:created_at).reverse
        posts = Kaminari.paginate_array(posts).page(params[:page]).per(10)
      elsif model == "user"
        User.where("name LIKE ?", "%#{keyword}%").where(is_active: true).page(params[:page]).per(20)
      elsif model == "review"
        Review.where("content LIKE ?", "%#{keyword}%").where(in_release: true).page(params[:page]).per(10).order(created_at: :DESC)
      elsif model == "tweet"
        Tweet.where("tweet_content LIKE ?", "%#{keyword}%").page(params[:page]).per(10).order(created_at: :DESC)
      else
        []
      end
    end
end
