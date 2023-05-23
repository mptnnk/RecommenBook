class Hashtag < ApplicationRecord
  has_many :hashtag_relations
  has_many :reviews, through: :hashtag_relations
  has_many :tweets, through: :hashtag_relations
end
