require 'faker'

FactoryGirl.define do
  factory :survey_answer do
    user
    meeting_occurrence
    question {  Question.all.sample[:question] }
    answer { ['yes', 'no'].sample }
    why { [Faker::Lorem.sentence, ''].sample }
  end
end