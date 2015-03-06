class Meeting < ActiveRecord::Base
  include IceCube

  store_accessor :repeat_rule, :frequency, :until, :count, :interval, :by_second, :by_minute, :by_hour,
                 :by_day, :by_month_day, :by_year_day, :by_week_number, :by_month, :by_set_position, :week_start
  has_many :meeting_occurrences, dependent: :destroy
  has_many :meeting_users, dependent: :destroy

  before_save :check_meeting_done
  after_save :update_or_create_nearest_occurrence!

  validates_presence_of :uid, :start_time, :end_time

  def organizer
    self.meeting_users.find_by(organizer: true).try(:user)
  end

  def meeting_user_participants
    self.meeting_users.where(organizer: false)
  end

  def participants
    User.joins(:meeting_users).where(meeting_users: {meeting: self, organizer: false})
  end

  def last_occurrence
    meeting_occurrences.where(occurred: false).last
  end

  def self.lookup(link_code)
    SurveyInvite.find_by(:link_code => link_code).meeting_occurrence.meeting
  end

  def self.where_ready_for_occurrence
    # joins(:meeting_occurrences).where('meeting_occurrences.occurred = false AND meeting_occurrences.end_time > ?', Time.now)
    joins(:meeting_occurrences).where(meeting_occurrences: {occurred: false, end_time: [2.weeks.ago..Time.now]})
  end

  def occur
    occurrence = meeting_occurrences.where('occurred = false').first
    return unless occurrence

    occurrence.update!(occurred: true)
    occurrence.send_invites
    # update_or_create_nearest_occurrence!
    # check_meeting_done
    save

    occurrence
  end

  def update_or_create_nearest_occurrence!
    last_occurrence = meeting_occurrences.where(occurred: false).last
    next_occurrence = schedule.next_occurrence
    if next_occurrence
      if last_occurrence
        last_occurrence.update!(start_time: next_occurrence.start_time,
                                end_time: next_occurrence.end_time)
      else
        generate_new_occurrence(next_occurrence.start_time, next_occurrence.end_time)
      end
    else
      # Meeting just created and has no future occurrences
      if meeting_occurrences.empty?
        last_occurred = schedule.last
        generate_new_occurrence(last_occurred.start_time, last_occurred.end_time)
      end
    end
  end

  def check_meeting_done
    last_occurrence = schedule.last
    if last_occurrence and last_occurrence.start_time > Time.now
      self.done = true
    elsif last_occurrence.nil? # No possible occurrences
      self.done = true
    else
      self.done = false
    end
    true
  end

  def schedule
    IceCube::Schedule.new(start_time, end_time: end_time) do |s|
      _ice_tea_hash = to_ice_tea_hash
      if _ice_tea_hash
        s.add_recurrence_rule(Rule.from_hash(_ice_tea_hash))
      end
    end
  end

  def to_ice_tea_hash
    # TODO: add :week_start
    return nil unless repeat_rule

    days_of_week = %w(SU MO TU WE TH FR SA)

    rule = {}

    rule['rule_type'] = case repeat_rule['frequency']
                          when 'DAILY' then IceCube::DailyRule.to_s
                          when 'WEEKLY' then IceCube::WeeklyRule.to_s
                          when 'MONTHLY' then IceCube::MonthlyRule.to_s
                          when 'YEARLY' then IceCube::YearlyRule.to_s
                          else return nil
                        end

    rule['interval'] = repeat_rule['interval']
    rule['week_start'] = repeat_rule['interval']
    rule['until'] = repeat_rule['until']
    rule['count'] = repeat_rule['count'] ? repeat_rule['count'].to_i : nil
    rule['validations'] = {}
    if repeat_rule['by_day']
      rule['validations']['day'] = repeat_rule['by_day'].scan(/(SU|MO|TU|WE|TH|FR|SA)/).map { |day| days_of_week.index(day[0]) }
    end

    if repeat_rule['by_month_day']
      rule['validations']['day_of_month'] = repeat_rule['by_month_day'][/\d{1,2}/].to_i
    end

    if repeat_rule['frequency'] == 'MONTHLY'
      if repeat_rule['by_day']
        _day_rule = repeat_rule['by_day'].scan(/(\d)(SU|MO|TU|WE|TH|FR|SA)/)[0]
        _day = days_of_week.index(_day_rule[1])
        _occs = _day_rule[0].to_i
        rule['validations']['day_of_week'] = { _day => [_occs]}
      end
    end

    # Check endless meetings
    if rule['until'].nil? and rule['count'].nil?
      rule['until'] = 20.years.since
    end

    rule
  end

  def refresh_meeting_users(emails)
    new_users = emails.map { |email| add_meeting_user(email) }
    redundant_users = meeting_user_participants - new_users
    redundant_users.each(&:delete)
  end

  def add_meeting_user(email, organizer=false)
    user = User.find_or_create_default!(email)

    meeting_user = MeetingUser.find_or_create_by!(meeting: self, user: user) do |u|
      u.organizer = organizer
    end

    unless organizer
      SurveyInvite.find_or_create_by!(meeting_occurrence: last_occurrence, user: user)
    end

    meeting_user
  end

  private

    def generate_new_occurrence(start_time, end_time)
      MeetingOccurrence.create!(meeting: self,
                                start_time: start_time,
                                end_time: end_time,
                                occurred: false)
    end
end
