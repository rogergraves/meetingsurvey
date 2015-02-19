class Meeting < ActiveRecord::Base
  store_accessor :repeat_rule, :frequency, :until, :count, :interval, :by_second, :by_minute, :by_hour,
                 :by_day, :by_month_day, :by_year_day, :by_week_number, :by_month, :by_set_position, :week_start
  has_many :meeting_occurrences, dependent: :destroy
  has_many :meeting_users, dependent: :destroy

  after_save :set_up_occurrence

  def organizer
    meeting_users.where(organizer: true).first.user
  end

  def self.lookup(link_code)
    SurveyInvite.find_by(:link_code => link_code).meeting_occurrence.meeting
  end

  def set_up_occurrence
    if meeting_occurrences.any?
      #   TODO: find last MeetingOccurrence and change it
    else
      MeetingOccurrence.create!(meeting: self,
                                start_time: start_time,
                                end_time: end_time)
    end
  end
end
