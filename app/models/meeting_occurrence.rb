class MeetingOccurrence < ActiveRecord::Base
  belongs_to :meeting
  has_many :survey_invites
  has_many :meeting_answers, :dependent => :destroy

  scope :fresh, -> { joins('LEFT JOIN survey_invites ON survey_invites.meeting_occurrence_id = meeting_occurrences.id').where('end_time > ? AND survey_invites.id ISNULL', Time.now) }
end
