require 'rails_helper'

module SurveySteps
  step "Setup data" do
    meeting = create(:meeting)
    user = create(:user)
    create(:meeting_participation, meeting: meeting, organizer: true)
    create(:meeting_participation, meeting: meeting, user: user)
  end

  step "Visit survey" do
    visit "/survey/#{SurveyInvite.first.link_code}"
  end

  step "Fill up and submit survey form" do
    choose 'answer_1_Yes'
    choose 'answer_2_Yes'
    choose 'answer_3_No'
    choose 'answer_4_Yes'
    choose 'answer_5_Yes'

    # NOTE: Looks like there is a bug in Firefox 35 and line below doesn't work.
    # For now I replaced it with JS.
    # fill_in 'answer_6', with: 'My awesome feedback text'
    page.execute_script("document.getElementById('answer_6').value = 'My awesome feedback text'")
    click_button 'Send'
  end

  step "Verify that data was saved successfully in the database" do
    expect(SurveyAnswer.count).to eq(6)
  end

  step "Receive email" do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []


    start_time = Time.new(2015, 4, 12, 10, 0)
    end_time   = start_time + 2.hours
    meeting = create(:meeting, start_time: start_time, end_time: end_time)
    organizer = meeting.add_meeting_user('organizer@example.com', true)
    participant = meeting.add_meeting_user('participant@example.com').user

    Timecop.travel(end_time + 1.minute)
    meeting.occur

    expect(ActionMailer::Base.deliveries.count).to eq(1)
    expect(open_last_email.to).to include(participant.email)

    Timecop.return
  end

  step "Open email and click 'I Attended'" do
    open_last_email.click_link('I Attended')
  end
end

RSpec.configure { |c| c.include SurveySteps }