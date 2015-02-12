FactoryGirl.define do
  factory :meeting_participation do
    user
    meeting
    organizer false
    confirmed_attendance [true, false].sample()
  end
end