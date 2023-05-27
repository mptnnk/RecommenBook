class Public::BooksController < ApplicationController
  
  def search
    genre_id = params[:book_genre_id]
    title = params[:title]
    author = params[:author]
    page = params[:page] || 1
    per = 30
    @books = []
    
    search_params = {
      page: page,
      hits: per,
      sort: 'sales'
    }
    
    if genre_id.present? && title.present? && author.present?
      search_params[:books_genre_id] = genre_id
      search_params[:title] = title
      search_params[:author] = author
      
    elsif genre_id.present? && title.present?
      search_params[:books_genre_id] = genre_id
      search_params[:title] = title
      
    elsif genre_id.present? && author.present?
      search_params[:books_genre_id] = genre_id
      search_params[:author] = author
      
    elsif title.present? && author.present?
      search_params[:title] = title
      search_params[:author] = author
    
    elsif genre_id.present?
      search_params[:books_genre_id] = genre_id
      
    elsif title.present?
      search_params[:title] = title
      
    elsif author.present?
      search_params[:author] = author
      
    elsif search_params.except(:page, :hits, :sort).empty?
      return
      
    end
    
    @books = RakutenWebService::Books::Book.search(search_params)
    @books_page = Kaminari.paginate_array([], total_count: @books.response['count']).page(page).per(per)
    puts search_results
    # pp @books.response['pageCount']　#,page,@books_page
    # response['']とすると、楽天ブックスAPIの出力パラメータで「全体情報」とされている部分についての情報が取れる
    
    if user_signed_in?
      @random_books = user_random_books
      if @random_books.present?
        @random_page = Kaminari.paginate_array([], total_count: @random_books.count ).page(page).per(per)
      end
    end
  end
  
  def show
    @book = RakutenWebService::Books::Book.search(isbn: params[:id]).first
    @review = Review.new
    @reviews = Review.where(isbn: @book.isbn).where(in_release: true).limit(4).order(created_at: :DESC)
    @tweet = Tweet.new
    @tweets = Tweet.where(isbn: @book.isbn).limit(4).order(created_at: :DESC)
    @book_favorites = FavoriteBook.where(isbn: @book.isbn)
    @tag = Hashtag.find_by(name: params[:name])
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
      flash.now[:notice]="検索結果を表示します（売れ行き順）"
    else
      flash.now[:alert]="該当する書籍はありません"
    end
  end
  
  def user_random_books
    # page = params[:page] || 1
    if current_user.favorite_books.present?
      recent_favorite_isbns = current_user.favorite_books.order(created_at: :DESC).limit(30).pluck(:isbn)
      genre_ids = []
      recent_favorite_isbns.each do |isbn|
        book = RakutenWebService::Books::Book.search(isbn: isbn).first
        genre_ids << book.genres.first['booksGenreId'] if book.present? && book.genres.present?
      end
      favorite_genre_ids = genre_ids.map { |id| id[0,6] }
      most_favorite_id = favorite_genre_ids.group_by(&:itself).max_by{ |_,count| count }.first
      related_books = RakutenWebService::Books::Book.search({
        books_genre_id: most_favorite_id,
        sort: 'sales',
        hits: 15
      })
      favorite_isbns = current_user.favorite_books.pluck(:isbn)
      related_books = related_books.reject{ |book| favorite_isbns.include?(book.isbn) }
      @random_books = related_books.sample(3)
    end
  end
  
end