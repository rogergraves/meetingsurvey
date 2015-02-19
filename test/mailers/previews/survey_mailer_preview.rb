class SurveyMailerPreview < ActionMailer::Preview

  def survey_invite
    user = User.first
    organizer = User.last
    survey_invite = SurveyInvite.all.sample

    SurveyMailer.survey_invite(user, organizer, survey_invite)
  end

end