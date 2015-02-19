require 'faker'
require 'securerandom'

FactoryGirl.define do
  factory :meeting do
    summary { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    start_time { 24.hours.from_now }
    end_time { 23.hours.from_now }
    created_time { 25.hours.from_now }
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
end