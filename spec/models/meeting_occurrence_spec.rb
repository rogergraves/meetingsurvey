require 'spec_helper'

describe MeetingOccurrence do
  let(:occurrence) { FactoryGirl.create(:meeting_occurrence) }

  it 'Factory works' do
    expect(occurrence.valid?).to eq(true)
  end

  context 'Relationships' do
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
end