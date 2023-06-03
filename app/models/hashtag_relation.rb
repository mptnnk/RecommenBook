class HashtagRelation < ApplicationRecord
  belongs_to :hashtag
  belongs_to :review, optional: true
  belongs_to :tweet, optional: true
  validates :hashtag_id, presence: true
end
