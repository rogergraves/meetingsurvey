FactoryGirl.define do
  factory :mail do
    from      { Faker::Internet.email }
    to        { Faker::Internet.email }
    subject   { Faker::Lorem.sentence }
    body      { Faker::Lorem.paragraph }

    initialize_with do
      Mail.new(attributes)
      # Mail.new do
      #   from from
      #   to to
      # end
    end
  end
end