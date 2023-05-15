class FavoriteBook < ApplicationRecord
  
  belongs_to :user
  validates :isbn, uniqueness: true
end
