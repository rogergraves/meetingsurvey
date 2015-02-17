class SurveyAnswer < ActiveRecord::Base
  belongs_to :user
  belongs_to :meeting_occurrence

  validates_presence_of :user, :meeting
  validates_uniqueness_of :question, :scope => [:meeting_id, :user_id]
end
