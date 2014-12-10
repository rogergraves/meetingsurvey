class MeetingParticipation < ActiveRecord::Base
  belongs_to :user
  belongs_to :meeting

  before_create :generate_link_code_if_missing
  validates_uniqueness_of :link_code
  validates_uniqueness_of :meeting_id, :scope => :user_id
  validates_uniqueness_of :organizer, :if => :organizer, :scope => :meeting_id

  private

  def generate_link_code_if_missing
    if self.link_code.blank?
      query_string = nil
      string_length = 20

      while query_string.nil? || MeetingParticipation.where(:link_code => query_string).present?
        query_string = rand(36**string_length).to_s(36)
        string_length += 1
      end

      self.link_code = query_string
    end
  end
end
