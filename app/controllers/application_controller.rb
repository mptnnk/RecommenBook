class ApplicationController < ActionController::Base
  
  # set controller : users, favorite_books, likes, relationships, reviews,
  
  def set_userinfo
    if params[:name].present?
      @user = User.find_by(name: params[:name])
    elsif params[:user_name].present?
      @user = User.find_by(name: params[:user_name])
    end
    
    @in_release_reviews = Review.where(user_id: @user.id, in_release: true).count
    
    @recommenbook = @user.favorite_books.find_by(recommenbook: true)
    if @recommenbook.present?
      @book = RakutenWebService::Books::Book.search(isbn: @recommenbook.isbn).first
    end
    
    @reviews = @user.reviews.where(in_release: true).limit(4).order(created_at: :DESC)
    @tweets = @user.tweets.limit(4).order(created_at: :DESC)
    @favorite_books = @user.favorite_books.limit(4).order(created_at: :DESC)
    @favorite_genres = @user.favorite_genres.all
  end
  
end
