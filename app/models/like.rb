class Like < ApplicationRecord
  belongs_to :user
  belongs_to :review, optional: true
  belongs_to :tweet, optional: true
  validates_uniqueness_of :review_id, scope: :user_id, if: :review_id?
  validates_uniqueness_of :tweet_id, scope: :user_id, if: :tweet_id?
  
  # def liked_by?(user)
  #   likes.where(user_id: user.id).exists?
  # end
end
