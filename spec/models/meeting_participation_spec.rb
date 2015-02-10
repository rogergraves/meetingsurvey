require 'spec_helper'

describe MeetingParticipation do
  let(:meeting_participation) { FactoryGirl.create(:meeting_participation) }

  it 'Factory works' do
    expect(meeting_participation).to be_valid
  end

  context 'Relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:meeting) }
  end

  context 'Validations' do
    it "user is required" do
      expect(meeting_participation).to be_valid
      meeting_participation.user_id = nil
      expect(meeting_participation).to_not be_valid
    end

    it "meeting is required" do
      expect(meeting_participation).to be_valid
      meeting_participation.meeting_id = nil
      expect(meeting_participation).to_not be_valid
    end

    it "generated link_code must be unique" do
      another_meeting_participation = FactoryGirl.create(:meeting_participation)
      expect(another_meeting_participation).to be_valid
      another_meeting_participation.link_code = meeting_participation.link_code
      expect(another_meeting_participation).to_not be_valid
    end

    it "user_id + meeting_id combination must be unique" do
      another_meeting = FactoryGirl.create(:meeting_participation)
      expect(another_meeting).to be_valid
      another_meeting.user_id = meeting_participation.user_id
      expect(another_meeting).to be_valid
      another_meeting.meeting_id = meeting_participation.meeting_id
      expect(another_meeting).to_not be_valid
    end

    it "only 1 organizer allowed" do
      meeting_participation.update_attributes(:organizer => true)
      new_participant = FactoryGirl.create(:meeting_participation, :meeting_id => meeting_participation.meeting_id)
      expect(new_participant).to be_valid
      new_participant.organizer = true
      expect(new_participant).to_not be_valid
      expect(FactoryGirl.build(:meeting_participation, :organizer => true)).to be_valid
    end
  end
end
