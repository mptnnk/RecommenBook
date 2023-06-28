FactoryBot.define do
  factory :genre do
    transient do
      # transientでモデルの属性以外のデータをファクトリに含めることができる。今回の場合だと「genre_id」という実際にモデルには定義されていないものを含めている。
      # transientは後で引用することができない。
      genre_id { Genre.pluck(:id).sample }
    end
    name { Genre.find(genre_id).name }
    book_genre_id { Genre.find(genre_id).book_genre_id }
  end
end
