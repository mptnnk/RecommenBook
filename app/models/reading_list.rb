class ReadingList < ApplicationRecord
  
  belongs_to :user
  validates :isbn, uniqueness: { scope: :user_id }
  
end
