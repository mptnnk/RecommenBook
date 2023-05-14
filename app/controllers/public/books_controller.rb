class Public::BooksController < ApplicationController
  
  def search
    genre_id = params[:book_genre_id]
    keyword = params[:keyword]
    page = params[:page] || 1
    per = 10
    # マジックナンバー：コード内に何度も出てくる数字のこと。変数指定しておけば変更しやすくてよい
    @books = []

    if genre_id.present? && keyword.present?
      @books = RakutenWebService::Books::Book.search({
        books_genre_id: genre_id,
        title: keyword,
        page: page,
        hits: per
      })
      p search_results
    elsif genre_id.present?
      @books = RakutenWebService::Books::Book.search({
        books_genre_id: genre_id,
        page: page,
        hits: per
      })
      p search_results
    elsif keyword.present?
      @books = RakutenWebService::Books::Book.search({
        title: keyword,
        page: page,
        hits: per
        
      })
    end
    
    @books_page = Kaminari.paginate_array([], total_count: @books.response['count'] ).page(page).per(per)
    #@books = @books.page(page)
    
    # pp @books.response['pageCount']　#,page,@books_page
    # ppをすると、ターミナルにどんなデータがとれたか出てくる。

  end
  
  def show
    @book = RakutenWebService::Books::Book.search(isbn: params[:id]).first
    # @favorite_book = current_user.favorite_books.find_by(isbn: params[:id]).first
    @review = Review.new
  end
  
  # def add_favorite
  #   isbn = params[:isbn]
  #   book_info = RakutenWebService::Books::Book.search(isbn: params[:id]).first
  #   current_user.favorite_books.create(
  #     isbn: isbn,
  #     title: book_info.title,
  #     author: book_info.author
  #   )
  #   redirect_to mypage_path(@user), notice: 'お気に入りの本を登録しました'
  # end


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