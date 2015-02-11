require 'icalendar'

FactoryGirl.define do
  factory :calendar, class: Icalendar::Calendar do
    # from      { Faker::Internet.email }
    events nil

    initialize_with do
      cal = Icalendar::Calendar.new
      events.each do |event|
        cal.add_event(event)
      end if events
      cal
    end
  end
end