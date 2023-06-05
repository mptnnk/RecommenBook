module ApplicationHelper
  def search_book(isbn)
    RakutenWebService::Books::Book.search(isbn: isbn, outOfStockFlag: 1).first
  end
end
