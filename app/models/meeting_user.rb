class MeetingUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :meeting

  validates_uniqueness_of :organizer, :if => :organizer, :scope => :meeting_id
end
