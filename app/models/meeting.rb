class Meeting < ActiveRecord::Base
  store_accessor :repeat_rule, :frequency, :until, :count, :interval, :by_second, :by_minute, :by_hour,
                 :by_day, :by_month_day, :by_year_day, :by_week_number, :by_month, :by_set_position, :week_start
  has_many :meeting_participations, :dependent => :destroy
  has_many :meeting_answers, :dependent => :destroy
  has_many :meeting_occurrences

  after_save :set_up_occurrence

  def organizer
    meeting_participations.where(organizer: true).first.user
  end

  def self.lookup link_code
    MeetingParticipation.find_by(:link_code => link_code).try(:meeting)
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
