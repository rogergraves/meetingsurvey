require "email_checker/email_checker"

namespace :survey do
  desc "Check for incoming emails with surveys"
  task check_email: :environment do
    EmailChecker.run
  end

  desc "Clear all"
  task clear: :environment do
    MeetingAnswer.delete_all
    MeetingOccurrence.delete_all
    Meeting.delete_all
    User.delete_all
  end

end
