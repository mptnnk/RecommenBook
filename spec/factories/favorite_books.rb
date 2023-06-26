FactoryBot.define do
  factory :favorite_book do
    user
    # isbn { Faker::Code.isbn }
    isbn { "9784122073708" }
    recommenbook { true }
  end
end