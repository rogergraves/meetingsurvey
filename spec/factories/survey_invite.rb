require 'securerandom'

FactoryGirl.define do
  factory :survey_invite do
    user
    meeting_occurrence
    confirmed_attendance { [true, false].sample }
    email_sent { 2.hours.ago }
    link_code { SecureRandom.hex(10) }
  end
end