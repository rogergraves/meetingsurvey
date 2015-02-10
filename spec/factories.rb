# Read about factories at https://github.com/thoughtbot/factory_girl

require 'securerandom'

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
    summary "Cool Meeting"
    description "Some description text"
    start_time 24.hours.from_now
    end_time 23.hours.from_now
    created_time 25.hours.from_now
    location "New York, USA"
    status "CONFIRMED"
    uid { SecureRandom.hex }

    repeat_rule(
        :frequency => "WEEKLY",
        :until => nil,
        :count => nil,
        :interval => nil,
        :by_second => nil,
        :by_minute => nil,
        :by_hour => nil,
        :by_day => ["MO", "TH"],
        :by_month_day => nil,
        :by_year_day => nil,
        :by_week_number => nil,
        :by_month => nil,
        :by_set_position => nil,
        :week_start => nil
    )
  end

  factory :meeting_participation do
    user
    meeting
    organizer false
    confirmed_attendance [true, false].sample()
  end

  factory :meeting_answer do
    user
    meeting
    question { Faker::Lorem.sentence.gsub('.', '?') }
    answer ['Yes', 'No'].sample()
    comments [nil, Faker::Lorem.sentence].sample()
  end
end