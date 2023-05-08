class Public::BooksController < ApplicationController
  
  def search
    genre_id = params[:book_genre_id]
    keyword = params[:keyword]
    @books = []
    
    if genre_id.present? && keyword.present?
      @books = RakutenWebService::Books::Book.search({
        books_genre_id: genre_id,
        title: keyword
      })
    elsif genre_id.present?
      @books = RakutenWebService::Books::Book.search({
        books_genre_id: genre_id
      })
    elsif keyword.present?
      @books = RakutenWebService::Books::Book.search({
        title: keyword
      })
    end

    # if params[:keyword]
    #   @books = RakutenWebService::Books::Book.search(title: params[:keyword])
    # end
  end
  
  def show
    @book = RakutenWebService::Books::Book.search(isbn: params[:id]).first
    @review = Review.new
  end


  private
  
  def book_params
    params.require(:book).permit(:book_genre_id, :isbn)
  end
  
end