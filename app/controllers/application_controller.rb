class ApplicationController < ActionController::Base
  
  # set : users, favorite_books, likes, relationships, reviews, review_comments, tweets
  
  def set_userinfo
    if params[:name].present?
      @user = User.find_by(name: params[:name], is_active: true)
    elsif params[:user_name].present?
      @user = User.find_by(name: params[:user_name], is_active: true)
    end
    
    if @user.present?
      @in_release_reviews = Review.where(user_id: @user.id, in_release: true).where.not(content: [nil, ''])
      if @user == current_user
        followings = current_user.followings.all
        @tweets = []
        @reviews = []
        followings.each do |follow|
          @tweets.concat(follow.tweets.all.order(created_at: :DESC))
          @reviews.concat(follow.reviews.all.order(created_at: :DESC))
        end
        @posts = (@tweets + @reviews)
        @posts = Kaminari.paginate_array(@posts).limit(10)
        @favorite_books = current_user.favorite_books.all
        @favorite_genres = current_user.favorite_genres.all
        @readed_lists_count = current_user.reviews.group(:isbn).size.count
        @reading_lists = current_user.reading_lists.all
        @recommenbook = current_user.favorite_books.find_by(recommenbook: true)
        if @recommenbook.present?
          @book = RakutenWebService::Books::Book.search({isbn: @recommenbook.isbn, outOfStockFlag: 1}).first
        end
        
      elsif @user != current_user
        @reviews = @user.reviews.where(in_release: true).where.not(content: [nil, '']).limit(4).order(created_at: :DESC)
        @tweets = @user.tweets.limit(4).order(created_at: :DESC)
        @favorite_books = @user.favorite_books.limit(4).order(created_at: :DESC)
        @favorite_genres = @user.favorite_genres.all
        @readed_lists_count = @user.reviews.group(:isbn).size.count
        @reading_lists = @user.reading_lists.all
        @recommenbook = @user.favorite_books.find_by(recommenbook: true)
        if @recommenbook.present?
          @book = RakutenWebService::Books::Book.search({isbn: @recommenbook.isbn, outOfStockFlag: 1}).first
        end
      end
      
    end
  end
  
end
