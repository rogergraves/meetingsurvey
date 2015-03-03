require 'rails_helper'

module ReportSteps
  include ReportHelper
  include ActionView::Helpers::UrlHelper

  step 'Meeting exists with last occurrence link code :link_code' do |link_code|
    @meeting = create(:meeting)
    @occurrence = @meeting.meeting_occurrences.last
    @occurrence.update(link_code: link_code)
  end

  step 'Meeting organizer exists' do
    @meeting.add_meeting_user('organizer@example.com', true)
  end

  step ':surveyed_users_count participants answered a survey' do |surveyed_users_count|
    surveyed_users_count = surveyed_users_count.to_i

    1.upto(surveyed_users_count) do |i|
      new_user = @meeting.add_meeting_user("participant#{i}@example.com").user
      new_user.survey_invites.find_by(meeting_occurrence: @occurrence).update(confirmed_attendance: true)
      6.times do
        create(:survey_answer, user: new_user, meeting_occurrence: @occurrence)
      end
    end

    expect(@occurrence.surveyed_users.count).to eq(surveyed_users_count)
  end

  step ':refused_users_count participants refused a survey' do |refused_users_count|
    refused_users_count = refused_users_count.to_i

    1.upto(refused_users_count) do |i|
      new_user = @meeting.add_meeting_user("refused_participant#{i}@example.com").user
      new_user.survey_invites.find_by(meeting_occurrence: @occurrence).update(confirmed_attendance: false)
    end

    expect(@occurrence.refused_users.count).to eq(refused_users_count)
  end

  step ':missed_users participants skipped a survey' do |missed_users|
    missed_users = missed_users.to_i

    1.upto(missed_users) do |i|
      @meeting.add_meeting_user("missed_participant#{i}@example.com").user
    end

    expect(@occurrence.missed_users.count).to eq(missed_users)
  end

  step 'I navigate to :path' do |path|
    visit path
  end

  step 'I should see on the page :message' do |message|
    expect(page).to have_content(message)
  end

  step 'I should see a list of absent participants' do
    users = @occurrence.refused_users
    expectation = "#{users[0...-1].map(&:email).join(', ')} and #{users.last.email} indicated that they were not present for the meeting."
    expect(page).to have_content(expectation)
  end

  step 'I should see a list of skipped participants' do
    users = @occurrence.missed_users
    expectation = "#{users[0...-1].map(&:email).join(', ')} and #{users.last.email} have not yet responded to the survey invite."
    expect(page).to have_content(expectation)
  end

  step 'qwe' do
    sleep 1
  end
end

RSpec.configure { |c| c.include ReportSteps }