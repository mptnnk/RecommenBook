class Like < ApplicationRecord
  belongs_to :user
  belongs_to :review, optional: true
  belongs_to :tweet, optional: true
  validates :review_id, uniqueness: { scope: :user_id, if: :review_id? }
  validates :tweet_id, uniqueness: { scope: :user_id, if: :tweet_id? }
  
  # def liked_by?(user)
  #   likes.where(user_id: user.id).exists?
  # end
end
