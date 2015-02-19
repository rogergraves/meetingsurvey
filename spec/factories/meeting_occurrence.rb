FactoryGirl.define do
  factory :meeting_occurrence do
    meeting
    start_time { 24.hours.from_now }
    end_time   { 23.hours.from_now }
  end
end