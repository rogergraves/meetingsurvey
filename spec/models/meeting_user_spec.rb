require 'spec_helper'

describe MeetingUser do
  let(:meeting_user) { FactoryGirl.create(:meeting_user) }

  it 'Factory works' do
    expect(meeting_user).to be_valid
  end

  context 'Relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:meeting) }
  end

  context 'Validations' do
    it "user is required" do
      expect(meeting_user).to be_valid
      meeting_user.user_id = nil
      expect(meeting_user).to_not be_valid
    end

    it "meeting is required" do
      expect(meeting_user).to be_valid
      meeting_user.meeting_id = nil
      expect(meeting_user).to_not be_valid
    end

    it "only 1 organizer allowed" do
      meeting_user.update_attributes(:organizer => true)
      new_meeting_user = FactoryGirl.create(:meeting_user, :meeting_id => meeting_user.meeting_id)
      expect(new_meeting_user).to be_valid
      new_meeting_user.organizer = true
      expect(new_meeting_user).to_not be_valid
      expect(FactoryGirl.build(:meeting_user, :organizer => true)).to be_valid
    end

  end
end