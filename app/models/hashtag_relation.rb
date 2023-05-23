class HashtagRelation < ApplicationRecord
  belongs_to :hashtag
  belongs_to :review, optional: true
  belongs_to :twett, optional: true
end
