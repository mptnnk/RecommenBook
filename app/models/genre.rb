class Genre < ApplicationRecord
  has_many :favorite_genres
  has_many :users, through: :favorite_genres, dependent: :destroy
end
