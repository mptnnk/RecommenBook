class Review < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :review_comments, dependent: :destroy
  
  has_many :hashtag_relations, dependent: :destroy
  has_many :hashtags, through: :hashtag_relations
  
  validates :content, presence: true, length: { maximum: 500 }
  
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
  
  after_create do
    review = Review.find_by(id: self.id)
    hashtags  = self.content.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    review.hashtags = []
    hashtags.uniq.map do |hashtag|
      #ハッシュタグは先頭の'#'を外した上で保存
      tag = Hashtag.find_or_create_by(name: hashtag.downcase.delete('#'))
      review.hashtags << tag
    end
  end

  before_update do 
    review = Review.find_by(id: self.id)
    review.hashtags.clear
    # 配列を空に（clear）
    hashtags = self.content.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    # caption = caption要素を生成　scan = selfに対してパターンを繰り返しマッチし、マッチした部分の文字列の配列を返す
    hashtags.uniq.map do |hashtag|
      tag = Hashtag.find_or_create_by(name: hashtag.downcase.delete('#'))
      review.hashtags << tag
    end
  end

end
