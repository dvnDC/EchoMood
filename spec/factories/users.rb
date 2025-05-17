FactoryBot.define do
  factory :user do
    nickname { "test" }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
