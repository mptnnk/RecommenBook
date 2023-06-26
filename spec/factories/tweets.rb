FactoryBot.define do
  factory :tweet do
    user
    isbn { "9784122073708" }
    tweet_content { Faker::Lorem.characters(number: 100) }
  end
end