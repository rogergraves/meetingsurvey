FactoryGirl.define do
  factory :meeting_user do
    user
    meeting
    organizer false
  end
end