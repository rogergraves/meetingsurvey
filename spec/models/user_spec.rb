require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  it 'Factory works' do
    expect(user.valid?).to eq(true)
  end

  context 'Relationships' do
    it { should have_many(:meeting_participations) }
    it 'does not orphan meeting_participations when users are deleted' do
      meeting_participation = FactoryGirl.create(:meeting_participation, :user => user)
      expect(MeetingParticipation.exists?(meeting_participation)).to eq(true)
      user.destroy
      expect(MeetingParticipation.exists?(meeting_participation)).to eq(false)
    end
  end
end
