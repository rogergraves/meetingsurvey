class MeetingOccurrence < ActiveRecord::Base
  belongs_to :meeting
  has_many :survey_invites
  has_many :meeting_answers, :dependent => :destroy
end
