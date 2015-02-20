require 'spec_helper'

describe MeetingOccurrence do
  let(:meeting) { FactoryGirl.create(:meeting) }
  let(:occurrence) { meeting.meeting_occurrences.take }
  # let(:occurrence) { FactoryGirl.create(:meeting_occurrence) }

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

  context "Scopes" do
    it "#fresh" do
      occurrence.update(start_time: 2.hours.from_now)
      old_occurrence = FactoryGirl.create(:meeting).meeting_occurrences.take
      old_occurrence.update(start_time: 2.hours.from_now)
      FactoryGirl.create_list(:survey_invite, 2, meeting_occurrence: old_occurrence)
      expect(MeetingOccurrence.fresh).to eq([occurrence])
    end
  end
end