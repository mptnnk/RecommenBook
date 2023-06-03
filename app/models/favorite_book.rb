class FavoriteBook < ApplicationRecord
  
  belongs_to :user
  validates :isbn, uniqueness: { scope: :user_id }
  # validates_uniqueness_of :recommenbook, scope: :user_id
  
end
