require 'rails_helper'

module SurveySteps

  step 'A survey invite exists with link code :link_code' do |link_code|
    meeting = create(:meeting)
    meeting.add_meeting_user('organizer@example.com', true)
    participant = meeting.add_meeting_user('participant@example.com').user
    meeting.generate_invites
    # survey_invite = meeting.last_occurrence.survey_invites.where(user: participant).take
    survey_invite = SurveyInvite.find_by(user: participant)
    survey_invite.update(link_code: link_code)
    expect(SurveyInvite.find_by(link_code: link_code).nil?).to be_falsey
  end

  step 'I navigate to :path' do |path|
    visit path
  end

  step 'I should see on the page :message' do |message|
    expect(page).to have_content(message)
  end

  step 'Field "confirmed_attendance" for survey invite with link code :link_code should be :boolean_value' do |link_code, boolean_value|
    invite = SurveyInvite.find_by(link_code: link_code)
    boolean_value = boolean_value == 'true'
    expect(invite.confirmed_attendance).to eq(boolean_value)
  end

  step 'I click on radio button :button_id' do |button_id|
    find("label[for=#{button_id}]").click
  end

  step 'I enter into :input_id text :text' do |input_id, text|
    fill_in input_id, with: text
  end

  step 'I click the link :link_id' do |link_id|
    click_link link_id
  end

  step 'I wait for :seconds seconds' do |seconds|
    sleep seconds.to_i
  end

  step 'The user for the invite with link code "1234567890" should have a survey answer with question "Was this meeting relevant to you?" answer "yes" and why "Because"' do
    answer = get_answer('1234567890', { question: 'Was this meeting relevant to you?',
                                        answer:   'yes',
                                        why:      'Because'
                                    })
    expect(answer.present?).to be_truthy
  end

  step 'The user for the invite with link code "1234567890" should have a survey answer with question "Was the purpose of this meeting clear?" answer "no" and no why' do
    answer = get_answer('1234567890', { question: 'Was the purpose of this meeting clear?',
                                        answer:   'no'
                                    })
    expect(answer.present?).to be_truthy
  end

  step 'The user for the invite with link code "1234567890" should have a survey answer with question "Any other feedback?" with why "Cool meeting!"' do
    answer = get_answer('1234567890', { question: 'Any other feedback?',
                                        answer:   'Cool meeting!'
                                    })
    expect(answer.present?).to be_truthy
  end

  def get_answer(link_code, options = {})
    invite = SurveyInvite.find_by(link_code: link_code)
    answers = invite.meeting_occurrence.survey_answers

    answers.find_by(question: [options[:question], ''],
                    answer:   [options[:answer], ''],
                    why:      [options[:why], ''])
  end
end

RSpec.configure { |c| c.include SurveySteps }