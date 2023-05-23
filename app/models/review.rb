class Review < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :review_comments, dependent: :destroy
  has_many :hashtags, through: :hashtag_relations
  
  validates :content, presence: true, length: { maximum: 500 }
  
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end
