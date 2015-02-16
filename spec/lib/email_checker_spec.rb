require 'spec_helper'
require 'email_checker/email_checker'

describe EmailChecker do
  let(:email) do
    event = FactoryGirl.build(:event)
    cal = FactoryGirl.build(:calendar, events: [event])
    email = FactoryGirl.build(:mail)
    email.attachments['invite.ics'] = { mime_type: 'application/ics', content: cal.to_ical }
    email
  end

  it "updates existing event with same UID" do
    expect(Meeting.count).to eq(0)
    EmailChecker.process_message(email)
    EmailChecker.process_message(email)
    expect(Meeting.count).to eq(1)
  end

  it "creates new Users" do
    expect(User.count).to eq(0)
    EmailChecker.process_message(email)
    expect(User.count).to eq(6)
  end

  it "creates unexisted Users" do
    EmailChecker.process_message(email)
    users_count = User.count

    cal = Icalendar.parse(email.attachments.first.body).first
    event = cal.events.first
    event.attendee << Icalendar::Values::CalAddress.new('mailto:new_user@example.com')
    new_email = FactoryGirl.build(:mail)
    new_email.attachments['invite.ics'] = { mime_type: 'application/ics', content: cal.to_ical }

    EmailChecker.process_message(new_email)
    expect(User.count).to eq(users_count + 1)
  end

  it "creates MeetingParticipations" do
    expect(SurveyInvite.count).to eq(0)
    EmailChecker.process_message(email)
    expect(SurveyInvite.count).to eq(6)
  end

  it "updates MeetingParticipations" do
    EmailChecker.process_message(email)
    counter = SurveyInvite.count
    EmailChecker.process_message(email)
    expect(SurveyInvite.count).to eq(counter)
  end
end