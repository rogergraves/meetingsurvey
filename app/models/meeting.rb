class Meeting < ActiveRecord::Base
  has_many :meeting_participations, :dependent => :destroy
  has_many :meeting_answers, :dependent => :destroy

  def self.lookup link_code
    MeetingParticipation.find_by(:link_code => link_code).try(:meeting)
  end
end
