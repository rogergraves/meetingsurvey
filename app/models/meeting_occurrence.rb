class MeetingOccurrence < ActiveRecord::Base
  belongs_to :meeting
  has_many :survey_invites, :dependent => :destroy
  has_many :survey_answers, :dependent => :destroy

  validates_presence_of :meeting, :start_time, :end_time
  validates_uniqueness_of :link_code

  before_create :generate_link_code

  scope :fresh, -> { joins('LEFT JOIN survey_invites ON survey_invites.meeting_occurrence_id = meeting_occurrences.id').where('end_time > ? AND survey_invites.id ISNULL', Time.now) }

  def send_invites
    participants = meeting.participants
    participants.each do |participant|
      survey_invite = SurveyInvite.find_or_create_by!(meeting_occurrence: self,
                                                      user: participant)
      survey_invite.send_email
    end
  end

  def surveyed_users
    User.joins(:survey_answers).where(survey_answers: {meeting_occurrence: self}).uniq
  end

  def refused_users
    User.joins(:survey_invites).where(survey_invites: {meeting_occurrence: self,
                                                       confirmed_attendance: false})
  end

  def missed_users
    User.joins(:survey_invites).where(survey_invites: {meeting_occurrence: self,
                                                       confirmed_attendance: nil})
  end

  # Returns hash-structured questions with answers
  #
  # {
  #     "Was this meeting relevant to you?"=>[
  #         {:answer=>"yes", :why=>"", :email=>"participant1@example.com"},
  #         {:answer=>"no", :why=>"Because", :email=>"participant2@example.com"},
  #     ],
  #     "Was the purpose of this meeting clear?"=>[
  #         {:answer=>"yes", :why=>"Don't know", :email=>"participant1@example.com"},
  #         {:answer=>"yes", :why=>"qewqwe", :email=>"participant2@example.com"},
  #     ]
  # }
  def questions_and_answers
    data = survey_answers.joins(:user)
               .select(:id, :user_id, :question, :answer, :why, 'users.email AS email')
               .to_a.map(&:serializable_hash)

    result = {}
    Question.all.each do |question|
      result[question[:question]] = []
      data.each do |d|
        if d['question'] == question[:question]
          result[question[:question]] << {
              answer: d['answer'],
              why: d['why'],
              email: d['email']
          }
        end
      end
    end

    result
  end

  private

    def generate_link_code
      loop do
        self.link_code = SecureRandom.hex(10)
        break unless MeetingOccurrence.exists?(link_code: link_code)
      end
    end
end
