require 'spec_helper'

describe MeetingOccurrence do
  let(:meeting) { FactoryGirl.create(:meeting) }
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

  context 'Callbacks' do
    it '#generate_link_code' do
      # puts "adasdasd #{meeting}"
      expect(occurrence.link_code).to_not be_nil
      expect(occurrence.link_code.size).to eq(20)

      new_occurrence = FactoryGirl.create(:meeting).meeting_occurrences.last
      new_occurrence.link_code = occurrence.link_code
      expect(new_occurrence).to_not be_valid
    end
  end
end