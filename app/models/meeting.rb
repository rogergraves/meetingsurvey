class Meeting < ActiveRecord::Base
  store_accessor :repeat_rule, :frequency, :until, :count, :interval, :by_second, :by_minute, :by_hour,
                 :by_day, :by_month_day, :by_year_day, :by_week_number, :by_month, :by_set_position, :week_start
  has_many :meeting_participations, :dependent => :destroy
  has_many :meeting_answers, :dependent => :destroy

  def self.lookup link_code
    MeetingParticipation.find_by(:link_code => link_code).try(:meeting)
  end
end
