class FavoriteBook < ApplicationRecord
  
  belongs_to :user
  validates_uniqueness_of :isbn, scope: :user_id
  # validates_uniqueness_of :recommenbook, scope: :user_id
  
end
