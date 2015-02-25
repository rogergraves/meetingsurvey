class Meeting < ActiveRecord::Base
  include IceCube

  store_accessor :repeat_rule, :frequency, :until, :count, :interval, :by_second, :by_minute, :by_hour,
                 :by_day, :by_month_day, :by_year_day, :by_week_number, :by_month, :by_set_position, :week_start
  has_many :meeting_occurrences, dependent: :destroy
  has_many :meeting_users, dependent: :destroy

  before_save :check_meeting_done
  after_save :update_or_create_nearest_occurrence!

  validates_presence_of :uid, :start_time, :end_time

  # TODO: delete this if needed
  scope :past_and_repeating, -> do
    # WHERE 'meetings'.repeat_rule -> 'frequency' = :frequency
    # TODO: left join
    find_by_sql(
        [%Q(SELECT DISTINCT ON("meetings"."id") "meetings".*  FROM "meetings"
            INNER JOIN (SELECT "meeting_occurrences"."id", "meeting_occurrences"."meeting_id"
                        FROM "meeting_occurrences"
                        WHERE "meeting_occurrences"."start_time" > ?
                        ORDER BY "start_time" ASC
                       ) AS "mo" ON "mo"."meeting_id" = "meetings"."id"
          WHERE defined("meetings"."repeat_rule", 'frequency')
          ORDER BY "meetings"."id";
        ),
         Time.now]
    )
  end

  # return type can be User or MeetingUser
  def organizer(type=:user)
    if type == :user
      meeting_users.where(organizer: true).first.user
    elsif type == :meeting_user
      meeting_users.where(organizer: true).first
    else
      raise 'Wrong argument: "type"'
    end
  end

  # return type can be User or MeetingUser
  def participants(type=:user)
    if type == :user
      User.joins(:meeting_users).where(meeting_users: {meeting: self, organizer: false})
    elsif type == :meeting_user
      meeting_users.where(organizer: false)
    else
      raise 'Wrong argument: "type"'
    end
  end

  def last_occurrence
    meeting_occurrences.where(occurred: false).last
  end

  def self.lookup(link_code)
    SurveyInvite.find_by(:link_code => link_code).meeting_occurrence.meeting
  end

  def self.where_ready_for_occurrence
    joins(:meeting_occurrences).where('meeting_occurrences.occurred = false AND meeting_occurrences.end_time > ?', Time.now)
  end

  def occur
    occurrence = meeting_occurrences.where('occurred = false AND end_time < ?', Time.now).first
    if occurrence
      occurrence.update!(occurred: true)
      occurrence.send_invites
    end
    # update_or_create_nearest_occurrence!
    check_meeting_done
    save!

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
        if next_occurrence
          MeetingOccurrence.create!(meeting: self,
                                    start_time: next_occurrence.start_time,
                                    end_time: next_occurrence.end_time,
                                    occurred: false)
        end
      end
    else
      # TODO: What todo if no occurrences will occur?
      #       Notify user about this by email
      last_occurrence.destroy if last_occurrence
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

    rule[:rule_type] = case repeat_rule['frequency']
                         when 'DAILY' then IceCube::DailyRule.to_s
                         when 'WEEKLY' then IceCube::WeeklyRule.to_s
                         when 'MONTHLY' then IceCube::MonthlyRule.to_s
                         when 'YEARLY' then IceCube::YearlyRule.to_s
                         else return nil
                       end

    rule[:interval] = repeat_rule['interval']
    rule[:week_start] = 0 #TODO: add week start to repeat rule
    rule[:until] = repeat_rule['until']
    rule[:count] = repeat_rule['count'] ? repeat_rule['count'].to_i : nil
    rule[:validations] = {}
    if repeat_rule['by_day']
      rule[:validations][:day] = repeat_rule['by_day'].scan(/(SU|MO|TU|WE|TH|FR|SA)/).map { |day| days_of_week.index(day[0]) }
    end

    if repeat_rule['by_month_day']
      rule[:validations][:day_of_month] = repeat_rule['by_month_day'][/\d{1,2}/].to_i
    end

    if repeat_rule['frequency'] == 'MONTHLY'
      if repeat_rule['by_day']
        _day_rule = repeat_rule['by_day'].scan(/(\d)(SU|MO|TU|WE|TH|FR|SA)/)[0]
        _day = days_of_week.index(_day_rule[1])
        _occs = _day_rule[0].to_i
        rule[:validations][:day_of_week] = { _day => [_occs]}
      end
    end

    # Check endless meetings
    unless rule[:until] and rule[:count]
      rule[:until] = 20.years.since
    end

    rule
  end

  def refresh_meeting_users(emails)
    new_users = emails.map { |email| add_meeting_user(email) }
    redundant_users = participants(:meeting_user) - new_users
    redundant_users.each(&:delete)
  end

  def add_meeting_user(email, organizer=false)
    if last_occurrence
      user = User.find_or_create_default!(email)

      MeetingUser.find_or_create_by!(meeting: self, user: user) do |u|
        u.organizer = organizer
      end
    end
  end

  # Generates SurveyInvites for all meeting users except organizer
  def generate_invites
    occurrence = last_occurrence
    if occurrence
      participants.each do |user|
        SurveyInvite.find_or_create_by!(meeting_occurrence: occurrence, user: user)
      end
    end
  end
end
