class Public::BooksController < ApplicationController
  
  def search
    genre_id = params[:book_genre_id]
    title = params[:title]
    author = params[:author]
    page = params[:page] || 1
    per = 30
    @books = []

    if genre_id.present? && title.present? && author.present?
      @books = RakutenWebService::Books::Book.search({
        books_genre_id: genre_id,
        title: title,
        author: author,
        page: page,
        hits: per,
        sort: 'sales'
      })
      @books_page = Kaminari.paginate_array([], total_count: @books.response['count'] ).page(page).per(per)
      p search_results
      
    elsif genre_id.present? && title.present?
      @books = RakutenWebService::Books::Book.search({
        books_genre_id: genre_id,
        title: title,
        page: page,
        hits: per,
        sort: 'sales'
      })
      @books_page = Kaminari.paginate_array([], total_count: @books.response['count'] ).page(page).per(per)
      p search_results
      
    elsif genre_id.present? && author.present?
      @books = RakutenWebService::Books::Book.search({
        books_genre_id: genre_id,
        author: author,
        page: page,
        hits: per,
        sort: 'sales'
      })
      @books_page = Kaminari.paginate_array([], total_count: @books.response['count'] ).page(page).per(per)
      p search_results
      
    elsif title.present? && author.present?
      @books = RakutenWebService::Books::Book.search({
        title: title,
        author: author,
        page: page,
        hits: per,
        sort: 'sales'
      })
      @books_page = Kaminari.paginate_array([], total_count: @books.response['count'] ).page(page).per(per)
      p search_results
      
    elsif genre_id.present?
      @books = RakutenWebService::Books::Book.search({
        books_genre_id: genre_id,
        page: page,
        hits: per,
        sort: 'sales'
      })
      @books_page = Kaminari.paginate_array([], total_count: @books.response['count'] ).page(page).per(per)
      p search_results
      
    elsif title.present?
      @books = RakutenWebService::Books::Book.search({
        title: title,
        page: page,
        hits: per,
        sort: 'sales'
      })
      @books_page = Kaminari.paginate_array([], total_count: @books.response['count'] ).page(page).per(per)
      p search_results
    
    elsif author.present?
      @books = RakutenWebService::Books::Book.search({
        author: author,
        page: page,
        hits: per,
        sort: 'sales'
      })
      @books_page = Kaminari.paginate_array([], total_count: @books.response['count'] ).page(page).per(per)
      p search_results
    end
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
    @tweets = Tweet.where(isbn: @book.isbn).order(created_at: :DESC).limit(4).order(created_at: :DESC)
    @book_favorites = FavoriteBook.where(isbn: @book.isbn)
    @tag = Hashtag.find_by(name: params[:name])
  end

  private
  
  def book_params
    params.require(:book).permit(:book_genre_id, :isbn)
  end
  
  def search_results
    if @books.present? && @books.count > 0
      flash.now[:notice]="検索結果を表示します（売れ行き順）"
    else
      flash.now[:alert]="該当する書籍はありません"
    end
  end
  
  def user_random_books
    page = params[:page] || 1
    if current_user.favorite_books.present?
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
      @random_books = related_books.sample(3)
    end
  end
  
end