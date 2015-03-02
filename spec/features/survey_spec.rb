require "rails_helper"

feature "Survey interaction" do
  scenario "User indicates that they didn't attend a meeting", js: true do
    @link_code = '1234567890'

    given_a_survey_invite
    and_i_navigate_to_refuse_attendance
    then_i_should_see_thanks_page
    and_survey_invite_should_be_refused
  end

  scenario "User indicates that they attended a meeting", js: true do
    @link_code = '1234567890'

    given_a_survey_invite
    and_i_navigate_to_confirm_attendance
    then_i_should_see_survey_page
    and_survey_invite_should_be_confirmed
  end

  scenario "User answers a survey", js: true do
    @link_code = '1234567890'

    given_a_survey_invite
    and_i_navigate_to_survey
    then_i_should_see_survey_page
    when_i_click_radio_button 'answer_1_yes'
    and_i_enter_text_into_why 'answer_1_why', 'Because'
    sleep 4
  end

  def given_a_survey_invite
    meeting = create(:meeting)
    meeting.add_meeting_user('organizer@example.com', true)
    meeting.add_meeting_user('oparticipant@example.com')
    meeting.generate_invites
    invite =meeting.last_occurrence.survey_invites.first
    invite.update(link_code: @link_code)
    expect(SurveyInvite.find_by(link_code: @link_code).present?).to be_truthy
  end

  def and_i_navigate_to_survey
    visit "/survey/#{@link_code}"
  end

  def and_i_navigate_to_refuse_attendance
    visit "/survey/#{@link_code}/refuse_attendance"
  end

  def and_i_navigate_to_confirm_attendance
    visit "/survey/#{@link_code}/confirm_attendance"
  end

  def then_i_should_see_thanks_page
    expect(page).to have_content('Thank you!')
  end

  def then_i_should_see_survey_page
    expect(page).to have_content('Was this meeting relevant to you?')
  end

  def and_survey_invite_should_be_refused
    invite = SurveyInvite.find_by(link_code: @link_code)
    expect(invite.confirmed_attendance).to be_falsey
  end

  def and_survey_invite_should_be_confirmed
    invite = SurveyInvite.find_by(link_code: @link_code)
    expect(invite.confirmed_attendance).to be_truthy
  end

  def when_i_click_radio_button(id)
    find("label[for=#{id}]").click
  end

  # TODO: fix it
  def and_i_enter_text_into_why(id, text)
    # fill_in id, with: text
    sleep 2
    fill_in "Have some comments?", with: text
    # find("##{id}").click
    # page.execute_script(%Q(document.getElementById('#{id}').value = '#{text}'))
  end

end