class ApplicationController < ActionController::Base
  include ApplicationHelper
  rescue_from ActiveRecord::RecordNotFound, with: :data_not_found
  rescue_from ActionController::RoutingError, with: :page_not_found

  # set :books, users, favorite_books, likes, relationships, reviews, review_comments, tweets, hashtags

  def set_userinfo
    if params[:name].present?
      @user = User.find_by(name: params[:name], is_active: true)
    elsif params[:user_name].present?
      @user = User.find_by(name: params[:user_name], is_active: true)
    end

    if @user.present?
      @in_release_reviews = Review.where(user_id: @user.id, in_release: true).where.not(content: [nil, ""])
      if @user == current_user
        followings = current_user.followings.where(is_active: true)
        @tweets = []
        @reviews = []
        followings.each do |follow|
          @tweets.concat(follow.tweets.all.order(created_at: :DESC))
          @reviews.concat(follow.reviews.where(in_release: true).where.not(content: [nil, ""]).order(created_at: :DESC))
        end
        @posts = (@tweets + @reviews).sort_by(&:created_at).reverse
        @posts = Kaminari.paginate_array(@posts).page(params[:page])
        @favorite_books = current_user.favorite_books.all
        @favorite_genres = current_user.favorite_genres.all
        @readed_lists_count = current_user.reviews.group(:isbn).size.count
        @reading_lists = current_user.reading_lists.all
        @recommenbook = current_user.favorite_books.find_by(recommenbook: true)
        if @recommenbook.present?
          @book = search_book(@recommenbook.isbn)
        end

      elsif @user != current_user
        @reviews = @user.reviews.where(in_release: true).where.not(content: [nil, ""]).limit(4).order(created_at: :DESC)
        @tweets = @user.tweets.limit(4).order(created_at: :DESC)
        @favorite_books = @user.favorite_books.limit(4).order(created_at: :DESC)
        @favorite_genres = @user.favorite_genres.all
        @readed_lists_count = @user.reviews.group(:isbn).size.count
        @reading_lists = @user.reading_lists.all
        @recommenbook = @user.favorite_books.find_by(recommenbook: true)
        if @recommenbook.present?
          @book = search_book(@recommenbook.isbn)
        end
      end

    end
  end

  private
    def data_not_found
      flash[:alert] = "データが見つかりません"
      redirect_back(fallback_location: root_path)
    end

    def data_not_found
      flash[:alert] = "ページが見つかりません"
      redirect_back(fallback_location: root_path)
    end
end
