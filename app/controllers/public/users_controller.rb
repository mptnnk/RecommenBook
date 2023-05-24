class Public::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :unsubscribe]
  before_action :set_current_user, only: [:edit, :update, :unsubscribe]
  
  def index
  end

  def show
    @user = User.find_by(name: params[:name])
    @in_release_reviews = Review.where(user_id: @user.id, in_release: true).count
    # ルーティングでURLに:nameを渡すことを指定しているので、キー=>カラムに当てはめて、nameがキーとなる場合はparamの中身のカラムは:nameが正しい。
    @recommenbook = @user.favorite_books.find_by(recommenbook: true)
    if @recommenbook.present?
      @book = RakutenWebService::Books::Book.search(isbn: @recommenbook.isbn).first
    end
    if @user.favorite_books.present?
      favorite_isbns = current_user.favorite_books.pluck(:isbn)
      recent_favorite_isbns = current_user.favorite_books.order(created_at: :DESC).limit(30).pluck(:isbn)
      genre_ids = []
      recent_favorite_isbns.each do |isbn|
        books = RakutenWebService::Books::Book.search(isbn: isbn).first
        genre_ids << books.books_genre_id
      end
      favorite_genre_ids = genre_ids.map { |id| id[0,6] }
      most_favorite_id = favorite_genre_ids.group_by(&:itself).max_by{ |_,count| count }.first
      # @genreid_count = @favorite_genre_ids.group_by(&:itself).map{ |key,value| [key, value.count] }.to_h
      # @most_favorite_genre_id = @genreid_count.max_by{ |_,count| count }&.first
      related_books = RakutenWebService::Books::Book.search({
        books_genre_id: most_favorite_id,
        sort: 'sales',
        hits: 15
      })
      related_books = related_books.reject{ |book| favorite_isbns.include?(book.isbn) }
      @random_book = related_books.sample
    end
  end

  def edit
  end
  
  def update
    @user.update(user_params) ? (redirect_to mypage_path(@user), notice: '会員情報を更新しました') : (render :edit)
  end

  def unsubscribe
  end
  
  def withdraw
    @user.update(is_active: false)
    reset_session
    redirect_to root_path, notice: '退会処理が完了しました'
  end
  
  private
  
  def user_params
    params.require(:user).permit(:book_id, :name, :email, :is_active, :profile_image)
  end
  
  def set_current_user
    @user = current_user
  end

end