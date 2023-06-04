class FavoriteBook < ApplicationRecord
  
  belongs_to :user
  validates :isbn, uniqueness: { scope: :user_id }
  # validates_uniqueness_of :recommenbook, scope: :user_id
  
  def self.recommend_book
    recommend = self.find_by(recommenbook: true)
    unless recommend.nil?
      book = RakutenWebService::Books::Book.search(isbn: recommend.isbn, outOfStockFlag: 1).first
      book['title']
    end
  end
end
