FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 6) }
    email { Faker::Internet.email }
    introduction { Faker::Lorem.characters(number: 10) }
    password { "password" }
    password_confirmation { "password" }

    after(:build) do |user|
      user.profile_image.attach(io: File.open("app/assets/images/default-image.png"), filename: "default-image.png", content_type: "application/xlsx")
    end
  end
end
