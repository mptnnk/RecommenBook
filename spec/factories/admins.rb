FactoryBot.define do
  factory :admin do
    email { ENV["ADMIN_MAIL"] }
    password { ENV["ADMIN_PASS"] }
  end
end