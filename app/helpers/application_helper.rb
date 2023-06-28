module ApplicationHelper
  def search_book(isbn)
    retry_count = 0
    # APIのリクエスト回数のカウント用
    begin
      RakutenWebService::Books::Book.search(isbn: isbn, outOfStockFlag: 1).first
      # begin = エラーが発生する可能性がある処理を開始する
    rescue RakutenWebService::TooManyRequests
      # rescue = エラーが発生した場合のエラー処理
      # too many requestsは楽天API側のエラーでリクエスト数が上限に達した場合に出現する
      if retry_count < 3
        # リクエスト回数が3未満の場合、リクエスト制限の回復を待つために10秒間待機しretry_countを1増やしてからbeginに戻る
        puts "API rate limit exceeded. Retrying in 10 seconds..."
        sleep(10)
        retry_count += 1
        retry
      else
        # リトライが3回以上になった場合、RuntimeErrorが発生する
        puts "Retry limit exceeded. Exiting..."
        raise
      end
    rescue StandardError => e
      # StandardErrorは通常プログラムで発生する可能性の高い例外クラスを束ねる
      puts "An error occurred: #{e.message}"
    end
  end
end
