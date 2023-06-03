class FavoriteGenre < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  validates :user_id, presence: true
  validates :genre_id, presence: true
end
