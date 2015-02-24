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

    # repeat_rule(
    #     :frequency => "WEEKLY",
    #     :until => nil,
    #     :count => nil,
    #     :interval => nil,
    #     :by_second => nil,
    #     :by_minute => nil,
    #     :by_hour => nil,
    #     :by_day => ["MO", "TH"],
    #     :by_month_day => nil,
    #     :by_year_day => nil,
    #     :by_week_number => nil,
    #     :by_month => nil,
    #     :by_set_position => nil,
    #     :week_start => nil
    # )

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
        count 2
        interval 1
      end

      after(:build) do |meeting, evaluator|
        meeting.repeat_rule = evaluator.default_repeat_rule
        meeting.repeat_rule[:frequency] = "DAILY"
        meeting.repeat_rule[:count]     = evaluator.count
        meeting.repeat_rule[:interval]  = evaluator.interval
        # user.name.upcase! if evaluator.upcased
      end
    end

    # factory :invalid_repeating_meeting do
    #   repeat_rule(
    #       :frequency => nil,
    #       :until => nil,
    #       :count => nil,
    #       :interval => nil,
    #       :by_second => nil,
    #       :by_minute => nil,
    #       :by_hour => nil,
    #       :by_day => nil,
    #       :by_month_day => nil,
    #       :by_year_day => nil,
    #       :by_week_number => nil,
    #       :by_month => nil,
    #       :by_set_position => nil,
    #       :week_start => nil
    #   )
    #
    #   factory :daily_repeating_meeting do
    #     transient do
    #       count 1
    #       interval 1
    #     end
    #
    #     after(:build) do |meeting, evaluator|
    #       meeting.repeat_rule[:frequency] = "DAILY"
    #       meeting.repeat_rule[:count]     = count
    #       meeting.repeat_rule[:interval]  = interval
    #       user.name.upcase! if evaluator.upcased
    #     end
    #   end
    # end

    # factory :daily_repeating_meeting do
    #   transient do
    #     count 1
    #     interval 1
    #   end
    #
    #   repeat_rule(
    #       :frequency => "DAILY",
    #       :until => nil,
    #       :count => nil,
    #       :interval => nil,
    #       :by_second => nil,
    #       :by_minute => nil,
    #       :by_hour => nil,
    #       :by_day => nil,
    #       :by_month_day => nil,
    #       :by_year_day => nil,
    #       :by_week_number => nil,
    #       :by_month => nil,
    #       :by_set_position => nil,
    #       :week_start => nil
    #   )
    #
    #   after(:build) do |meeting, evaluator|
    #     meeting.repeat_rule[:count] = count
    #     meeting.repeat_rule[:interval] = interval
    #     user.name.upcase! if evaluator.upcased
    #   end
    # end
  end
end