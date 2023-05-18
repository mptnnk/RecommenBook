class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  validates :tweet_content, presence: true, length: { maximum: 200 }

end
