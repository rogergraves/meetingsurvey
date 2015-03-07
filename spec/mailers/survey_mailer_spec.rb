require 'rails_helper'

describe SurveyMailer do

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe '#first_answer' do
    let(:meeting) do
      _meeting = create(:meeting)
      _meeting.add_meeting_user('organizer@example.com', true)
      _meeting.add_meeting_user('participant@example.com')
      _meeting
    end

    let(:participant) { meeting.meeting_user_participants.take.user }

    let(:email) { SurveyMailer.first_answer(participant, meeting.last_occurrence) }

    it 'has subject' do
      expect(email).to have_subject 'The first response is in!'
    end

    it 'has participant and meeting' do
      expect(email).to have_body_text "#{participant.email} responded to the Meeting Survey for #{meeting.summary}"
    end

    it 'has link to report' do
      expect(email).to have_body_text report_url(meeting.last_occurrence.link_code)
    end

    it 'has no proposal to check report again if it has only one participant' do
      expect(email).to_not have_body_text "Feel free to check the link from time to time. We'll also send you an email once everyone has responded."
    end

    it 'has no proposal to check report again if it has more than one participant' do
      meeting.add_meeting_user('another_participant@example.com')
      expect(email).to have_body_text "Feel free to check the link from time to time. We'll also send you an email once everyone has responded."
    end
  end

  describe '#survey_done' do
    let(:meeting) do
      _meeting = create(:meeting)
      _meeting.add_meeting_user('organizer@example.com', true)
      _meeting.add_meeting_user('participant@example.com')
      _meeting
    end

    let(:occurrence) { meeting.last_occurrence }

    let(:email) { SurveyMailer.survey_done(occurrence) }

    it 'has subject' do
      expect(email).to have_subject 'All results are in!'
    end

    it 'has link to report' do
      expect(email).to have_body_text report_url(meeting.last_occurrence.link_code)
    end
  end

end