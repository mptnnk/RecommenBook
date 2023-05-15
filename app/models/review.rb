class Review < ApplicationRecord
  belongs_to :user
  # belongs_to :book
  validates :content, length: { maximum: 500 }
end
