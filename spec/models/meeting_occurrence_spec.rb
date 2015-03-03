require 'spec_helper'

describe MeetingOccurrence do
  let(:meeting) { create(:meeting) }
  let(:occurrence) { meeting.meeting_occurrences.last }

  it 'Factory works' do
    expect(occurrence.valid?).to eq(true)
  end

  context 'Relationships' do
    it { should belong_to(:meeting) }
    it { should have_many(:survey_invites) }
    it { should have_many(:survey_answers) }

    it 'does not orphan survey_invites when occurrence is deleted' do
      survey_invite = FactoryGirl.create(:survey_invite, meeting_occurrence: occurrence)
      expect(SurveyInvite.exists?(id: survey_invite.id)).to be_truthy
      occurrence.destroy
      expect(SurveyInvite.exists?(id: survey_invite.id)).to be_falsey
    end

    it 'does not orphan survey_answers when occurrence is deleted' do
      survey_answer = FactoryGirl.create(:survey_answer, meeting_occurrence: occurrence)
      expect(SurveyAnswer.exists?(id: survey_answer.id)).to be_truthy
      occurrence.destroy
      expect(SurveyAnswer.exists?(id: survey_answer.id)).to be_falsey
    end
  end

  context 'Instance methods' do
    before :each do
      @surveyed_users_count = 4
      @refused_users_count = 2
      @missed_users = 3

      meeting.add_meeting_user('organizer@example.com', true)

      1.upto(@surveyed_users_count) do |i|
        new_user = meeting.add_meeting_user("participant#{i}@example.com").user
        new_user.survey_invites.find_by(meeting_occurrence: occurrence).update(confirmed_attendance: true)
        6.times do
          create(:survey_answer, user: new_user, meeting_occurrence: occurrence)
        end
      end

      1.upto(@refused_users_count) do |i|
        new_user = meeting.add_meeting_user("refused_participant#{i}@example.com").user
        new_user.survey_invites.find_by(meeting_occurrence: occurrence).update(confirmed_attendance: false)
      end

      1.upto(@missed_users) do |i|
        meeting.add_meeting_user("missed_participant#{i}@example.com").user
      end
    end

    it '#surveyed_users' do
      expected_users = occurrence.surveyed_users

      expect(expected_users.count).to eq(@surveyed_users_count)

      1.upto(@surveyed_users_count) do |i|
        expect(expected_users).to include(User.find_by(email: "participant#{i}@example.com"))
      end

      1.upto(@refused_users_count) do |i|
        expect(expected_users).to_not include(User.find_by(email: "refused_participant#{i}@example.com"))
      end

      1.upto(@missed_users) do |i|
        expect(expected_users).to_not include(User.find_by(email: "missed_participant#{i}@example.com"))
      end
    end

    it '#refused_users' do
      expected_users = occurrence.refused_users

      expect(expected_users.count).to eq(@refused_users_count)

      1.upto(@refused_users_count) do |i|
        expect(expected_users).to include(User.find_by(email: "refused_participant#{i}@example.com"))
      end

      1.upto(@surveyed_users_count) do |i|
        expect(expected_users).to_not include(User.find_by(email: "participant#{i}@example.com"))
      end

      1.upto(@missed_users) do |i|
        expect(expected_users).to_not include(User.find_by(email: "missed_participant#{i}@example.com"))
      end
    end

    it '#missed_users' do
      expected_users = occurrence.missed_users

      1.upto(@missed_users) do |i|
        expect(expected_users).to include(User.find_by(email: "missed_participant#{i}@example.com"))
      end

      1.upto(@surveyed_users_count) do |i|
        expect(expected_users).to_not include(User.find_by(email: "participant#{i}@example.com"))
      end

      1.upto(@refused_users_count) do |i|
        expect(expected_users).to_not include(User.find_by(email: "refused_participant#{i}@example.com"))
      end
    end
  end

  context 'Callbacks' do
    it '#generate_link_code' do
      expect(occurrence.link_code).to_not be_nil
      expect(occurrence.link_code.size).to eq(20)

      new_occurrence = FactoryGirl.create(:meeting).meeting_occurrences.last
      new_occurrence.link_code = occurrence.link_code
      expect(new_occurrence).to_not be_valid
    end
  end
end