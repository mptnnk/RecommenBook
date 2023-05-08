class Public::BooksController < ApplicationController
  
  def search
    if params[:keyword]
      @books = RakutenWebService::Books::Book.search(title: params[:keyword])
    elsif params[:genre_name]
      get_genre_id = RakutenWebService::Books::Genre.serch(books_genre_id: params[:genre_name])
      @books = get_genre_id.book.all
    end
  end
  
  private

  
end