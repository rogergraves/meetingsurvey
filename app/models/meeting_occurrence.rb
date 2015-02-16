class MeetingOccurrence < ActiveRecord::Base
  belongs_to :meeting
  has_many :survey_invites
end
