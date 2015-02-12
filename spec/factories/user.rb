FactoryGirl.define do
  factory :user do
    email     { Faker::Internet.email }
    password  "1Password!2"
    name      { Faker::Internet.user_name }
  end
end