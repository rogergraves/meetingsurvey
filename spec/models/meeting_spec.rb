require 'spec_helper'

describe Meeting do
  let(:meeting) { FactoryGirl.create(:meeting) }

  it 'Factory works' do
    expect(meeting.valid?).to eq(true)
  end

  context 'Relationships' do
    it { should have_many(:meeting_occurrences) }
    it { should have_many(:meeting_users) }
    it 'does not orphan meeting_occurrences when meeting is deleted' do
      meeting_occurrence = FactoryGirl.create(:meeting_occurrence, meeting: meeting)
      expect(MeetingOccurrence.exists?(id: meeting_occurrence.id)).to be_truthy
      meeting.destroy
      expect(MeetingOccurrence.exists?(id: meeting_occurrence.id)).to be_falsey
    end

    it 'does not orphan meeting_users when meeting is deleted' do
      meeting_user = FactoryGirl.create(:meeting_user, meeting: meeting)
      expect(MeetingUser.exists?(id: meeting_user.id)).to be_truthy
      meeting.destroy
      expect(MeetingUser.exists?(id: meeting_user.id)).to be_falsey
    end
  end

  context "Class methods" do
    it "#self.lookup" do
      survey_invite = FactoryGirl.create(:survey_invite, meeting_occurrence: meeting.meeting_occurrences.take)
      expect(Meeting.lookup(survey_invite.link_code)).to eq(meeting)
    end

    it "#self.where_ready_for_occurrence" do
      # create(:daily_repeating_meeting, start_time: 1.day.since, end_time: 1.day.since + 1.hour)
      # create(:daily_repeating_meeting, start_time: 2.day.since, end_time: 2.day.since + 1.hour)
      # create(:daily_repeating_meeting, start_time: 2.day.ago, end_time: 2.day.ago + 1.hour)
      # puts "---- #{create(:daily_repeating_meeting)}"
      # puts "---- #{create(:daily_repeating_meeting).repeat_rule[:count]}"
    end

    it "#organizer" do
      organizer = create(:meeting_user, meeting: meeting, organizer: true).user
      participant = create(:meeting_user, meeting: meeting, organizer: false).user
      expect(meeting.organizer).to eq(organizer)
    end


  end
end
