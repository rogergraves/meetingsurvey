require 'spec_helper'

module SurveySteps
  step "Setup data" do
    meeting = create(:meeting)
    user = create(:user)
    create(:meeting_participation, meeting: meeting, organizer: true)
    create(:meeting_participation, meeting: meeting, user: user)
  end

  step "Visit survey" do
    visit "/survey/#{MeetingParticipation.first.link_code}"
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
    expect(MeetingAnswer.count).to eq(6)
  end
end

RSpec.configure { |c| c.include SurveySteps }