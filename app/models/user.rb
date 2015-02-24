class User < ActiveRecord::Base

  DEFAULT_PASSWORD = '1234567890'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :survey_invites, :dependent => :destroy
  has_many :survey_answers, :dependent => :destroy
  has_many :meeting_users

  def self.find_or_create_default!(email)
    find_or_create_by!(email: email) do |user|
      user.password = DEFAULT_PASSWORD
    end
  end
end
