require 'spec_helper'

describe MeetingParticipation do
  let(:meeting_participation) { FactoryGirl.create(:meeting_participation) }

  it 'Factory works' do
    expect(meeting_participation.valid?).to eq(true)
  end

  context 'Relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:meeting) }
  end

  context 'Validations' do
    # Add validation tests here
  end
end
