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

    # Question 1
    when_i_click_radio_button 'answer_1_yes'
    and_i_enter_text_into_why 'answer_1_why', 'Because'
    and_i_click_nex_answer 'answer_1_next'

    # Question 2
    when_i_click_radio_button 'answer_2_no'
    and_i_click_nex_answer 'answer_2_next'

    # Question 3
    when_i_click_radio_button 'answer_3_yes'
    and_i_click_nex_answer 'answer_3_next'

    # Question 4
    when_i_click_radio_button 'answer_4_yes'
    and_i_click_nex_answer 'answer_4_next'

    # Question 5
    when_i_click_radio_button 'answer_5_yes'
    and_i_click_nex_answer 'answer_5_next'

    # Question 5
    and_i_answer_textual 'answer_6', 'Cool meeting!'
    and_i_click_finish

    sleep 1

    then_answer_should_exists(question: 'Was this meeting relevant to you?',
                              answer:   'yes',
                              why:      'Because')

    then_answer_should_exists(question: 'Was the purpose of this meeting clear?',
                              answer:   'no')

    then_answer_should_exists(question: 'Any other feedback?',
                              answer:   'Cool meeting!')


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

  def and_i_enter_text_into_why(id, text)
    fill_in id, with: text
  end

  def and_i_click_nex_answer(id)
    click_link id
  end

  def and_i_answer_textual(id, text)
    fill_in id, with: text
  end

  def and_i_click_finish
    click_link 'submit'
  end

  def then_answer_should_exists(options = {})
    invite = SurveyInvite.find_by(link_code: @link_code)
    answers = invite.meeting_occurrence.survey_answers

    answer = answers.find_by(question: [options[:question], ''],
                             answer:   [options[:answer], ''],
                             why:      [options[:why], ''])

    expect(answer.nil?).to be_falsey
  end
end