require "email_checker/email_checker"

namespace :survey do
  desc "Check for incoming emails with surveys"
  task check_email: :environment do
    EmailChecker.run
  end

end
