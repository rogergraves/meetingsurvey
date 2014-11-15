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
    it "generated link_code must be unique" do
      another_meeting_participation = FactoryGirl.create(:meeting_participation)
      expect(another_meeting_participation.valid?).to eq(true)
      another_meeting_participation.link_code = meeting_participation.link_code
      expect(another_meeting_participation.valid?).to eq(false)
    end
  end
end
