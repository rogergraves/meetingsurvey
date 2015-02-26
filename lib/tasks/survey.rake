require "email_checker/email_checker"

namespace :survey do
  desc "Check for incoming emails with surveys"
  task check_email: :environment do
    EmailChecker.check_email
  end

  desc "Send invites for meetings"
  task send_invites: :environment do
    EmailChecker.send_invites
  end

  desc "Clean all"
  task clean: :environment do
    SurveyAnswer.delete_all
    SurveyInvite.delete_all
    MeetingOccurrence.delete_all
    MeetingUser.delete_all
    Meeting.delete_all
    User.delete_all
  end

end
