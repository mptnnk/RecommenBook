class Public::TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  
  def new
    @book = RakutenWebService::Books::Book.search(isbn: params[:book_id]).first
    @book_isbn = @book["isbn"]
    @tweet = Tweet.new
  end
  
  def create
  end

  def index
  end

  def show
  end
  
  def destroy
  end
  
  private
  
  def tweet_params
    params.require(:tweet).permit(:isbn, :tweet_content,).merge(user_id :current_user.id)
  end
  
end
