class Meeting < ActiveRecord::Base
  has_many :meeting_participations, :dependent => :destroy
  has_many :meeting_answers, :dependent => :destroy
end
