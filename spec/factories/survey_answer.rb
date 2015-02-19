require 'faker'

FactoryGirl.define do
  factory :survey_answer do
    user
    meeting_occurrence
    question { Faker::Lorem.sentence }
    answer { ['Yes', 'No'].sample }
    why { Faker::Lorem.sentence }
  end
end