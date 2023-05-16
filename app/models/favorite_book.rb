class FavoriteBook < ApplicationRecord
  
  belongs_to :user
  validates_uniqueness_of :isbn, scope: :user_id
  
end