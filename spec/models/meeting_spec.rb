require 'rails_helper'

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

  describe "Meeting without repetitions" do
    before :each do
      @meeting = create(:meeting)
    end

    it "only one occurrence can be" do
      expect(@meeting.schedule.all_occurrences.count).to eq(1)
    end

    context "Class methods" do
      it "#last_occurrence" do
        expect(@meeting.last_occurrence.start_time).to eq_time(@meeting.start_time)
        expect(@meeting.last_occurrence.end_time).to eq_time(@meeting.end_time)
      end
    end
  end

  describe "Daily repeating meeting" do
    context "Ends after nth repetitions" do
      it "has proper occurrences count" do
        @meeting = create(:daily_repeating_meeting, count: 5, interval: 4)
        expect(@meeting.schedule.all_occurrences.count).to eq(5)
      end

      it "has proper occurrences time" do
        start_time = 2.days.since
        end_time   = start_time + 2.hours
        count = 3
        interval = 4
        @meeting = create(:daily_repeating_meeting, start_time: start_time, end_time: end_time, count: 3, interval: 4)
        occurrences = @meeting.schedule.all_occurrences
        count.times do |i|
          expect(occurrences[i].start_time).to eq(start_time + (i * interval).days)
        end
      end
    end

    context "Ends after special date" do
      before :all do
        @start_time = 2.days.since
        @end_time   = @start_time + 2.hours
        @days_count = 10
        @interval = 3
        @meeting = create(:daily_repeating_meeting,
                          start_time: @start_time,
                          end_time:   @end_time,
                          until_time: @days_count.days.since,
                          interval:   @interval)
      end

      it "has proper occurrences count" do
        expect(@meeting.schedule.all_occurrences.count).to eq(@days_count / @interval)
      end

      it "has proper occurrences time" do
        occurrences = @meeting.schedule.all_occurrences
        (@days_count / @interval).times do |i|
          expect(occurrences[i].start_time).to eq(@start_time + (i * @interval).days)
        end
      end
    end
  end

  describe "Weekly repeating meeting" do
    context "Ends after nth repetitions" do
      it "has proper occurrences count" do
        start_time = 2.days.since
        end_time   = start_time + 2.hours
        count      = 5
        interval   = 2
        by_day     = %w(SU MO TU WE TH FR SA)
        @meeting = create(:weekly_repeating_meeting,
                          start_time: start_time,
                          end_time:   end_time,
                          count:      count,
                          interval:   interval,
                          by_day:     by_day)
        expect(@meeting.schedule.all_occurrences.count).to eq(count)
      end
    end
  end

  describe "Monthly repeating meeting" do
    context "Ends after nth repetitions" do
      it "has proper occurrences count by day of month" do
        start_time   = 2.days.since
        end_time     = start_time + 2.hours
        count        = 5
        interval     = 2
        by_month_day = %w(12)
        @meeting = create(:weekly_repeating_meeting,
                          start_time:   start_time,
                          end_time:     end_time,
                          count:        count,
                          interval:     interval,
                          by_month_day: by_month_day)
        expect(@meeting.schedule.all_occurrences.count).to eq(count)
      end

      it "has proper occurrences count by day of week" do
        start_time   = 2.days.since
        end_time     = start_time + 2.hours
        count        = 5
        interval     = 2
        by_day       = %w(4TH)
        @meeting = create(:weekly_repeating_meeting,
                          start_time:   start_time,
                          end_time:     end_time,
                          count:        count,
                          interval:     interval,
                          by_day:       by_day)
        expect(@meeting.schedule.all_occurrences.count).to eq(count)
      end
    end

    describe "Yearly repeating meeting" do
      context "Ends after nth repetitions" do
        it "has proper occurrences count" do
          start_time   = 2.days.since
          end_time     = start_time + 2.hours
          count        = 5
          interval     = 2
          @meeting = create(:yearly_repeating_meeting,
                            start_time:   start_time,
                            end_time:     end_time,
                            count:        count,
                            interval:     interval)
          expect(@meeting.schedule.all_occurrences.count).to eq(count)
        end
      end
    end
  end

  context "Class methods" do
    it "#self.lookup" do
      survey_invite = FactoryGirl.create(:survey_invite, meeting_occurrence: meeting.meeting_occurrences.take)
      expect(Meeting.lookup(survey_invite.link_code)).to eq(meeting)
    end

    it "#self.where_ready_for_occurrence" do
      create(:daily_repeating_meeting, start_time: 1.day.since, end_time: 1.day.since + 1.hour)
      # create(:daily_repeating_meeting, start_time: 2.day.since, end_time: 2.day.since + 1.hour)
      # create(:daily_repeating_meeting, start_time: 2.day.ago, end_time: 2.day.ago + 1.hour)
      # puts "---- #{create(:daily_repeating_meeting)}"
      # puts "---- #{create(:daily_repeating_meeting).repeat_rule[:count]}"
    end

    it "#organizer" do
      organizer = create(:meeting_user, meeting: meeting, organizer: true)
      participant = create(:meeting_user, meeting: meeting, organizer: false)

      expect(meeting.organizer).to eq(organizer.user)
      expect(meeting.organizer(:user)).to eq(organizer.user)
      expect(meeting.organizer(:meeting_user)).to eq(organizer)
    end

    it "#participants" do
      organizer    = create(:meeting_user, meeting: meeting, organizer: true)
      participant1 = create(:meeting_user, meeting: meeting, organizer: false)
      participant2 = create(:meeting_user, meeting: meeting, organizer: false)

      expect(meeting.participants).to eq([participant1.user, participant2.user])
      expect(meeting.participants(:user)).to eq([participant1.user, participant2.user])
      expect(meeting.participants(:meeting_user)).to eq([participant1, participant2])
    end

    it "#generate_invites" do
      organizer    = create(:meeting_user, meeting: meeting, organizer: true)
      participant1 = create(:meeting_user, meeting: meeting, organizer: false)
      participant2 = create(:meeting_user, meeting: meeting, organizer: false)
      meeting.generate_invites

      expect(SurveyInvite.where(meeting_occurrence: meeting.last_occurrence).count).to eq(2)
    end

    describe "#add_meeting_user" do
      it "adds a participant to users and meeting_users table" do
        email = 'participant@example.com'
        meeting.add_meeting_user(email)
        user = User.find_by(email: email)
        expect(user.email).to eq(email)
        meeting_user = MeetingUser.find_by(meeting: meeting, user: user)
        expect(meeting_user.user.email).to eq(email)
        expect(meeting_user.organizer?).to be_falsey
      end

      it "adds an organizer" do
        email = 'participant@example.com'
        meeting.add_meeting_user(email, true)
        user = User.find_by(email: email)
        expect(user.email).to eq(email)
        meeting_user = MeetingUser.find_by(meeting: meeting, user: user)
        expect(meeting_user.user.email).to eq(email)
        expect(meeting_user.organizer?).to be_truthy
      end
    end
  end
end
