class MeetingOccurrence < ActiveRecord::Base
  belongs_to :meeting
  has_many :survey_invites, :dependent => :destroy
  has_many :survey_answers, :dependent => :destroy

  validates_presence_of :meeting, :start_time, :end_time
  validates_uniqueness_of :link_code

  before_create :generate_link_code

  scope :fresh, -> { joins('LEFT JOIN survey_invites ON survey_invites.meeting_occurrence_id = meeting_occurrences.id').where('end_time > ? AND survey_invites.id ISNULL', Time.now) }

  def send_invites
    participants = meeting.meeting_users.where('organizer = false')
    participants.each do |participant|
      survey_invite = SurveyInvite.find_or_create_by!(meeting_occurrence: self,
                                                      user: participant.user)
      survey_invite.send_email
    end
  end

  private

    def generate_link_code
      loop do
        self.link_code = SecureRandom.hex(10)
        break unless MeetingOccurrence.exists?(link_code: link_code)
      end
    end
end
