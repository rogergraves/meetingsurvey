require 'spec_helper'

describe Meeting do
  let(:meeting) { FactoryGirl.create(:meeting) }

  it 'Factory works' do
    expect(meeting.valid?).to eq(true)
  end

  context 'Relationships' do
    it { should have_many(:meeting_participations) }
    it { should have_many(:meeting_answers) }
    it 'does not orphan meeting_participations when meeting is deleted' do
      meeting_participation = FactoryGirl.create(:meeting_participation, :meeting => meeting)
      expect(MeetingParticipation.exists?(id: meeting_participation.id)).to be_truthy
      meeting.destroy
      expect(MeetingParticipation.exists?(id: meeting_participation.id)).to be_falsey
    end

    it 'does not orphan meeting_answers when meeting is deleted' do
      meeting_answer = FactoryGirl.create(:meeting_answer, :meeting => meeting)
      expect(MeetingAnswer.exists?(id: meeting_answer.id)).to be_truthy
      meeting.destroy
      expect(MeetingAnswer.exists?(id: meeting_answer.id)).to be_falsey
    end
  end

  context "Class methods" do
    it "#self.lookup" do
      meeting_participation = FactoryGirl.create(:meeting_participation, :meeting => meeting)
      expect(Meeting.lookup(meeting_participation.link_code)).to eq(meeting)
    end
  end
end
