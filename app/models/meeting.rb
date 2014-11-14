class Meeting < ActiveRecord::Base
  has_many :meeting_participations, :dependent => :destroy

end
