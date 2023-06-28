class Hashtag < ApplicationRecord
  validates :hashname, presence: true, length: { maximum: 99 }
  has_many :hashtag_relations
  has_many :reviews, through: :hashtag_relations
  has_many :tweets, through: :hashtag_relations
end
