class Public::BooksController < ApplicationController
  
  def search
    genre_id = params[:book_genre_id]
    keyword = params[:keyword]
    page = params[:page] || 1
    per = 30
    @books = []

    if genre_id.present? && keyword.present?
      @books = RakutenWebService::Books::Book.search({
        books_genre_id: genre_id,
        title: keyword,
        page: page,
        hits: per,
        sort: '-releaseDate'
      })
      @books_page = Kaminari.paginate_array([], total_count: @books.response['count'] ).page(page).per(per)
      p search_results
    elsif genre_id.present?
      @books = RakutenWebService::Books::Book.search({
        books_genre_id: genre_id,
        page: page,
        hits: per,
        sort: '-releaseDate'
      })
      @books_page = Kaminari.paginate_array([], total_count: @books.response['count'] ).page(page).per(per)
      p search_results
    elsif keyword.present?
      @books = RakutenWebService::Books::Book.search({
        title: keyword,
        page: page,
        hits: per,
        sort: '-releaseDate'
      })
      @books_page = Kaminari.paginate_array([], total_count: @books.response['count'] ).page(page).per(per)
      p search_results
    end

    #@books = @books.page(page)
    
    # pp @books.response['pageCount']　#,page,@books_page
    # response['']とすると、楽天ブックスAPIの出力パラメータで「全体情報」とされている部分についての情報が取れる

  end
  
  def show
    @book = RakutenWebService::Books::Book.search(isbn: params[:id]).first
    # @favorite_book = current_user.favorite_books.find_by(isbn: params[:id]).first
    @review = Review.new
    @reviews = Review.where(isbn: @book.isbn).page(params[:page]).per(10)
  end

  private
  
  def book_params
    params.require(:book).permit(:book_genre_id, :isbn)
  end
  
  def search_results
    if @books.present? && @books.count > 0
      flash.now[:notice]="検索結果を表示します（新着順）"
    else
      flash.now[:alert]="該当する書籍はありません"
    end
  end
  
end