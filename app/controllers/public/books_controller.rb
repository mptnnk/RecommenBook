class Public::BooksController < ApplicationController
  
  # def search
  #   if params[:keyword]
  #     @books = RakutenWebService::Books::Book.search(title: params[:keyword])
  #   end
  #   @genres = RakutenWebService::Books::Genre.root
  # end
  
  def search
    @book = Book.new
    @keyword = params[:keyword]
    @genres = Genre.all
    @selected_genre_id = params[:genre_id]
    @books = []
    
    if @selected_genre_id.present? && @keyword.present?
      @books = RakutenWebService::Books::Book.search({
        booksGenreId: @selected_genre_id,
        keyword: @keyword
      })
    elsif @selected_genre_id.present?
      @books = RakutenWebService::Books::Book.search({
        booksGenreId: @selected_genre_id
      })
    elsif @keyword.present?
      @books = RakutenWebService::Books::Book.search({
        keyword: @keyword
      })
    end
  end
    
  private
  
  def book_params
    params.require(:book).permit(:genre_id, :isbn)
  end

end