class Public::BooksController < ApplicationController
  before_action :set_userinfo
  
  def search
    genre_id = params[:book_genre_id]
    title = params[:title]
    author = params[:author]
    page = params[:page] || 1
    per = 30
    @books = []
    
    @random_books = user_random_books
    if @random_books.present?
      @random_page = Kaminari.paginate_array([], total_count: @random_books.count ).page(page).per(per)
    end
    
    if genre_id.blank? && title.blank? && author.blank?
      return
    end
    
    search_params = {
      page: page,
      hits: per,
      sort: 'sales',
      outOfStockFlag: 1,
    }
    
    search_params[:books_genre_id] = genre_id if genre_id.present?
    search_params[:title] = title if title.present?
    search_params[:author] = author if author.present?

    @books = RakutenWebService::Books::Book.search(search_params)
    @books_page = Kaminari.paginate_array([], total_count: @books.response['count']).page(page).per(per)
    puts search_results
    # pp @books.response['pageCount']　#,page,@books_page
    # response['']とすると、楽天ブックスAPIの出力パラメータで「全体情報」とされている部分についての情報が取れる
  end
  
  def show
    @review = Review.new
    @tweet = Tweet.new
    @tag = Hashtag.find_by(hashname: params[:hashname])
    
    isbn = params[:id]
    @book = RakutenWebService::Books::Book.search(isbn: isbn, outOfStockFlag: 1).first
    @reviews = Review.where(isbn: isbn).where(in_release: true).where.not(content: [nil, '']).limit(4).order(created_at: :DESC)
    @tweets = Tweet.where(isbn: isbn).limit(4).order(created_at: :DESC)
    @book_favorites = FavoriteBook.where(isbn: isbn)
  end

  private
  
  def book_params
    params.require(:book).permit(:book_genre_id, :isbn)
  end
  
  def books_page
    @books_page = Kaminari.paginate_array([], total_count: @books.response['count'] ).page(page).per(per)
  end
  
  def search_results
    if @books.present? && @books.count > 0
      
    else
      flash.now[:alert]="条件にあう本がなかったよ ;("
    end
  end
  
  def user_random_books
    if user_signed_in? && current_user.favorite_books.present?
      recent_favorite_isbns = current_user.favorite_books.order(created_at: :DESC).limit(30).pluck(:isbn)
      genre_ids = []
      recent_favorite_isbns.each do |isbn|
        book = RakutenWebService::Books::Book.search(isbn: isbn, outOfStockFlag: 1).first
        genre_ids << book.genres.first['booksGenreId'] if book.present? && book.genres.present?
      end
      favorite_genre_ids = genre_ids.map { |id| id[0,6] }
      most_favorite_id = favorite_genre_ids.group_by{|e| e}.sort_by{ |e,v| -v.size }.map(&:first).first
      related_books = RakutenWebService::Books::Book.search({
        books_genre_id: most_favorite_id,
        outOfStockFlag: 1,
        sort: 'sales',
        hits: 15
      })
      favorite_isbns = current_user.favorite_books.pluck(:isbn)
      related_books = related_books.reject{ |book| favorite_isbns.include?(book.isbn) }
      random_books = related_books.sample(3)
    end
  end
  
end