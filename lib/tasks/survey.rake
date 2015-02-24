require "email_checker/email_checker"
require 'meeting_utils/meeting_occurrence_utils'

namespace :survey do
  desc "Check for incoming emails with surveys"
  task check_email: :environment do
    EmailChecker.check_email
  end

  desc "Send invites for meetings"
  task send_invites: :environment do
    EmailChecker.send_invites
  end

  # TODO: remove this
  desc "Update_repetition MeetingOccurrences"
  task update_repetitions: :environment do
    MeetingOccurrenceUtils.update_repetitions
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
