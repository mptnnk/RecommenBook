FactoryBot.define do
  factory :review do
    user
    isbn { "9784122073708" }
    content { Faker::Lorem.characters(number: 200) }
    readed_at { Faker::Time.backward(days: 30) } # 過去30日以内のランダムの日付
    in_release { true }
    spoiler { false }
    rate { Faker::Number.between(from: 1, to: 5) }
  end
end
