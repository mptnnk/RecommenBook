class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :tweet_comments, dependent: :destroy
  hat_many :hashtags, through: :hashtag_relations
  
  validates :tweet_content, presence: true, length: { maximum: 200 }
  
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end
