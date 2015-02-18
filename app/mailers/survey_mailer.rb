class SurveyMailer < ApplicationMailer

  def survey_invite(user, organizer, survey_invite)
    @user = user
    @organizer = organizer
    @survey_invite = survey_invite
    mail(to: @user.email, subject: "Did you attend the #{survey_invite.meeting_occurrence.meeting.summary}")
  end

  def hello
    mail(to: 'kasianov.michael@gmail.com', subject: "Hello")
    # mail(to: 'kasianov.michael@gmail.com',
    #      body: 'qewqwe',
    #      content_type: "text/html",
    #      subject: "Hello")
  end
end
