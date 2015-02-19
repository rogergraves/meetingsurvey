class SurveyAnswer < ActiveRecord::Base
  belongs_to :user
  belongs_to :meeting_occurrence

  validates_presence_of :user, :meeting_occurrence, :question, :answer
  validates_uniqueness_of :question, :scope => [:meeting_occurrence_id, :user_id]
end
