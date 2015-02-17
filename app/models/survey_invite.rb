# MeetingParticipation
class SurveyInvite < ActiveRecord::Base
  belongs_to :user
  belongs_to :meeting_occurrence

  before_create :generate_link_code_if_missing
  validates_presence_of :user, :meeting_occurrence
  validates_uniqueness_of :link_code
  validates_uniqueness_of :meeting_occurrence_id, :scope => :user_id

  private

  def generate_link_code_if_missing
    if self.link_code.blank?
      query_string = nil
      string_length = 20

      while query_string.nil? || SurveyInvite.where(:link_code => query_string).present?
        query_string = rand(36**string_length).to_s(36)
        string_length += 1
      end

      self.link_code = query_string
    end
  end
end
