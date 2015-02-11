require 'icalendar'

FactoryGirl.define do
  factory :event, class: Icalendar::Event  do
    # dtstart     { Icalendar::Values::Date.new('20150211') }
    # @dtstart=Wed, 11 Feb 2015
    # @dtstart=Sat, 14 Feb 2015 11:29:23 +0000
    organizer   { "mailto:#{Faker::Internet.email}" }
    attendee    { 5.times.map { "mailto:#{Faker::Internet.email}" }.concat([organizer]) }
    dtstart     { 3.days.since }
    dtend       { dtstart + 2.hours }
    summary     { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    created     { 2.hours.from_now }
    status      'CONFIRMED'
    rrule       'FREQ=WEEKLY;BYDAY=MO,TH'

    initialize_with do
      Icalendar::Event.new do |e|
        e.dtstart     = dtstart
        e.dtend       = dtend
        e.summary     = summary
        e.description = description
        e.created     = created
        e.status      = status
        e.rrule       = rrule
      end
    end
  end
end