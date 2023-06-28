# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create!(
  email: ENV["ADMIN_MAIL"],
  password: ENV["ADMIN_PASS"]
)

book_arr = RakutenWebService::Books::Genre.root.children.first.children.map do |book|
  h = {}
  # 空のハッシュを作成
  h[book["booksGenreId"]] = book["booksGenreName"]
  # ハッシューにキーと値を追加。キーはbooksGenreId、値はbooksGenreName
  h
  # ブロックの最後に評価され配列に追加される
end

book_arr.each do |book|
  Genre.create(name:  book.first[1], book_genre_id:  book.first[0])
end
