# Use rake survey:clear to clean DB before seeds

require 'faker'
require 'securerandom'

def generate_meeting
  my_rand = rand(1..4)
  meeting = Meeting.new(
      uid: SecureRandom.hex,
      summary: Faker::Lorem.sentence,
      description: Faker::Lorem.sentence,
      start_time: my_rand.days.since,
      end_time: my_rand.days.since + 2.hours,
      created_time: Time.now - my_rand.days,
      location: Faker::Address.street_address,
      status: 'CONFIRMED'
  )

  rule = {
      frequency: 'WEEKLY',
      until: nil,
      count: nil,
      interval: nil,
      by_second: nil,
      by_minute: nil,
      by_hour: nil,
      by_day: ["MO", "TH"],
      by_month_day: nil,
      by_year_day: nil,
      by_week_number: nil,
      by_month: nil,
      by_set_position: nil,
      week_start: nil
  }

  meeting.repeat_rule = rule

  meeting.save!
  meeting
end


5.times do
  meeting = generate_meeting
  meeting_occurrence = meeting.meeting_occurrences.first

  7.times do
    user = User.create!(email: Faker::Internet.email, password: '12345678' )
    MeetingUser.create!(meeting: meeting, user: user)
    SurveyInvite.create!(meeting_occurrence: meeting_occurrence, user: user)
  end
  meeting.meeting_users.take.update!(organizer: true)
end