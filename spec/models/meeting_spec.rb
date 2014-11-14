require 'spec_helper'

describe Meeting do
  let(:meeting) { FactoryGirl.create(:meeting) }

  it 'Factory works' do
    expect(meeting.valid?).to eq(true)
  end

  context 'Relationships' do
    it { should have_many(:meeting_participations) }
    it 'does not orphan meeting_participations when meeting is deleted' do
      meeting_participation = FactoryGirl.create(:meeting_participation, :meeting => meeting)
      expect(MeetingParticipation.exists?(meeting_participation)).to eq(true)
      meeting.destroy
      expect(MeetingParticipation.exists?(meeting_participation)).to eq(false)
    end
  end
end
