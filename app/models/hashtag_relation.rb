class HashtagRelation < ApplicationRecord
  belongs_to :hashtag
  belongs_to :review
  validates :hashtag_id, presence: true
end
