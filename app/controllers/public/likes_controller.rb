class Public::LikesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  
  def create
    if params[:review_id]
      review = Review.find(params[:review_id])
      @review_like = current_user.likes.new(review_id: review.id)
      @review_like.save
      render 'review_replace_btn'
    elsif params[:tweet_id]
      tweet = Tweet.find(params[:tweet_id])
      @tweet_like = current_user.likes.new(tweet_id: tweet.id)
      @tweet_like.save
      render 'tweet_replace_btn'
    end
  end
  
  def index
    # if params[:user_id]
      @user = User.find(params[:user_id])
      tweet_likes = Like.where(user_id: @user.id).where.not(tweet_id: nil)
      # likeテーブルの中でtweet_idがnilでないものを「tweet_likes」として抽出する。
      @tweets = Tweet.joins(:likes).where(likes: { id: tweet_likes.pluck(:id) })
      # TweetモデルにLikeモデルを結合させ、両テーブルが関連づいたTweetの情報を取得する。
      # tweet_likes.pluck(:id)は、tweet_likes（＝likeのうちtweet_idが含まれている配列）から各likeのIDを抽出した配列を作成する。
      # where(likes: {id :pluckの配列})は、likeのIDがpluckの配列に含まれているツイートをフィルタリングする。
      review_likes = Like.where(user_id: @user.id).where.not(review_id: nil)
      @reviews = Review.joins(:likes).where(likes: { id: review_likes.pluck(:id)})
      @combined_records = @tweets + @reviews
      @combined_records = @combined_records.sort_by { |record| -record.likes.count }
      @recommenbook = @user.favorite_books.find_by(recommenbook: true)
      if @recommenbook.present?
        @book = RakutenWebService::Books::Book.search(isbn: @recommenbook.isbn).first
      end
    # else
    #   tweet_likes = Like.where.not(tweet_id: nil)
    #   @tweets = Tweet.joins(:likes).where(likes: { id: tweet_likes.pluck(:id) })
    #   review_likes = Like.where.not(review_id: nil)
    #   @reviews = Review.joins(:likes).where(likes: { id: review_likes.pluck(:id)})
    #   @combined_records = @tweets + @reviews
    #   @combined_records = @combined_records.sort_by { |record| -record.likes.count }
      
    # end
    # 全体のいいね一覧を作成することがなければif~elseは不要
  end
  
  def destroy
    if params[:review_id]
      review = Review.find(params[:review_id])
      @review_like = current_user.likes.find_by(review_id: review.id)
      @review_like.destroy
      render 'review_replace_btn'
    elsif params[:tweet_id]
      tweet = Tweet.find(params[:tweet_id])
      @tweet_like = current_user.likes.find_by(tweet_id: tweet.id)
      @tweet_like.destroy
      render 'tweet_replace_btn'
    end
  end
  
end
