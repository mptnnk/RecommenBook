class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :tweet_comments, dependent: :destroy
  
  has_many :hashtag_relations, dependent: :destroy
  has_many :hashtags, through: :hashtag_relations
  
  validates :tweet_content, presence: true, length: { maximum: 200 }
  
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
  
  after_create do
    tweet = Tweet.find_by(id: self.id)
    hashtags  = self.tweet_content.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    tweet.hashtags = []
    hashtags.uniq.map do |hashtag|
      tag = Hashtag.find_or_create_by(name: hashtag.downcase.delete('#＃'))
      tweet.hashtags << tag
    end
  end

  before_update do 
    tweet = Tweet.find_by(id: self.id)
    tweet.hashtags.clear
    hashtags = self.tweet_content.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      tag = Hashtag.find_or_create_by(name: hashtag.downcase.delete('#＃'))
      tweet.hashtags << tag
    end
  end
end
