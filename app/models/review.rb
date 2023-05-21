class Review < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :review_comments, dependent: :destroy
  
  validates :content, presence: true, length: { maximum: 500 }
  
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end
