class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :survey_invites, :dependent => :destroy
  has_many :meeting_answers, :dependent => :destroy
  has_many :meeting_users
end
