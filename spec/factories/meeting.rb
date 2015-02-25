require 'faker'
require 'securerandom'

FactoryGirl.define do

  # Simple meeting without repeat rule
  factory :meeting do
    summary       { Faker::Lorem.sentence }
    description   { Faker::Lorem.sentence }
    start_time    { 24.hours.from_now }
    end_time      { 23.hours.from_now }
    created_time  { 25.hours.from_now }
    location      "New York, USA"
    status        "CONFIRMED"
    uid           { SecureRandom.hex }

    transient do
      default_repeat_rule  ({
          :frequency => nil,
          :until => nil,
          :count => nil,
          :interval => nil,
          :by_second => nil,
          :by_minute => nil,
          :by_hour => nil,
          :by_day => nil,
          :by_month_day => nil,
          :by_year_day => nil,
          :by_week_number => nil,
          :by_month => nil,
          :by_set_position => nil,
          :week_start => nil
      })
    end

    factory :daily_repeating_meeting do
      transient do
        count      nil
        interval   1
        until_time nil
      end

      after(:build) do |meeting, evaluator|
        meeting.repeat_rule = evaluator.default_repeat_rule
        meeting.repeat_rule['frequency'] = 'DAILY'
        meeting.repeat_rule['count']     = evaluator.count
        meeting.repeat_rule['interval']  = evaluator.interval
        meeting.repeat_rule['until']     = evaluator.until_time
      end
    end

    factory :weekly_repeating_meeting do
      transient do
        count      nil
        interval   1
        until_time nil
        by_day     nil    # ["SU", "MO", "TU", "WE", "TH", "FR", "SA"]
      end

      after(:build) do |meeting, evaluator|
        meeting.repeat_rule = evaluator.default_repeat_rule
        meeting.repeat_rule['frequency'] = 'WEEKLY'
        meeting.repeat_rule['count']     = evaluator.count
        meeting.repeat_rule['interval']  = evaluator.interval
        meeting.repeat_rule['until']     = evaluator.until_time
        meeting.repeat_rule['by_day']    = evaluator.by_day.to_s
      end
    end

    factory :monthly_repeating_meeting do
      transient do
        count        nil
        interval     1
        until_time   nil
        by_day       nil # ["4TH"]
        by_month_day nil # ["12"]
      end

      after(:build) do |meeting, evaluator|
        meeting.repeat_rule = evaluator.default_repeat_rule
        meeting.repeat_rule['frequency']    = 'MONTHLY'
        meeting.repeat_rule['count']        = evaluator.count
        meeting.repeat_rule['interval']     = evaluator.interval
        meeting.repeat_rule['until']        = evaluator.until_time
        meeting.repeat_rule['by_day']       = evaluator.by_day
        meeting.repeat_rule['by_month_day'] = evaluator.by_month_day
      end
    end

    factory :yearly_repeating_meeting do
      transient do
        count      nil
        interval   1
        until_time nil
      end

      after(:build) do |meeting, evaluator|
        meeting.repeat_rule = evaluator.default_repeat_rule
        meeting.repeat_rule['frequency'] = 'DAILY'
        meeting.repeat_rule['count']     = evaluator.count
        meeting.repeat_rule['interval']  = evaluator.interval
        meeting.repeat_rule['until']     = evaluator.until_time
      end
    end
  end
end