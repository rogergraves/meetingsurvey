# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@factory.com"
  end
  sequence :name do |n|
    "Joe Schmoe#{n}"
  end

  factory :user do
    email
    password "1Password!2"
    name
  end

  factory :meeting do
    title "Cool Meeting"
    start_time 24.hours.from_now
    end_time 25.hours.from_now
    time_zone "Pacific Time (US & Canada)"
  end

  factory :meeting_participation do
    user
    meeting
    organizer false
    confirmed_attendance [true, false].sample()
  end
end