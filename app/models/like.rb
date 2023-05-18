class Like < ApplicationRecord
  belongs_to :user
  belongs_to :review
  belongs_to :tweet
  validates_uniqueness_of :review_id, scope: :user_id
  validates_uniqueness_of :tweet_id, scope: :user_id
  
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end
