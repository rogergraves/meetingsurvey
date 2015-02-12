FactoryGirl.define do
  factory :meeting_answer do
    user
    meeting
    question { Faker::Lorem.sentence.gsub('.', '?') }
    answer ['Yes', 'No'].sample()
    comments [nil, Faker::Lorem.sentence].sample()
  end
end
