class Public::BooksController < ApplicationController
  
  def search
    genre_id = params[:book_genre_id]
    keyword = params[:keyword]
    @books = []

    if genre_id.present? && keyword.present?
      @books = RakutenWebService::Books::Book.search({
        books_genre_id: genre_id,
        title: keyword,
      })
      p search_results
    elsif genre_id.present?
      @books = RakutenWebService::Books::Book.search({
        books_genre_id: genre_id
      })
      p search_results
    elsif keyword.present?
      @books = RakutenWebService::Books::Book.search({
        title: keyword,
        page: params[:page],
      })
      p search_results
    end

    # if params[:keyword]
    #   @books = RakutenWebService::Books::Book.search(title: params[:keyword])
    # end
  end
  
  def show
    @book = RakutenWebService::Books::Book.search(isbn: params[:id]).first
    @favorite_book = current_user.favorite_books.find_by(isbn: params[:id]).first
    @review = Review.new
  end
  
  def add_favorite
    isbn = params[:isbn]
    book_info = RakutenWebService::Books::Book.search(isbn: params[:id]).first
    current_user.favorite_books.create(
      isbn: isbn,
      title: book_info.title,
      author: book_info.author
    )
    redirect_to mypage_path(@user), notice: 'お気に入りの本を登録しました'
  end


  private
  
  def book_params
    params.require(:book).permit(:book_genre_id, :isbn)
  end
  
  def search_results
    if @books.present? && @books.count > 0
      flash.now[:notice]="検索結果を表示します"
    else
      flash.now[:alert]="該当する書籍はありません"
    end
  end
  
end