module ApplicationHelper
  # def search_book(isbn)
  #   RakutenWebService::Books::Book.search(isbn: isbn, outOfStockFlag: 1).first
  # end
  
  def search_book(isbn)
    retry_count = 0
  
    begin
      RakutenWebService::Books::Book.search(isbn: isbn, outOfStockFlag: 1).first
    rescue RakutenWebService::TooManyRequests
      if retry_count < 3
        puts "API rate limit exceeded. Retrying in 10 seconds..."
        sleep(10)
        retry_count += 1
        retry
      else
        puts "Retry limit exceeded. Exiting..."
        raise
      end
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  end

end
