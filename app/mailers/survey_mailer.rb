class SurveyMailer < ApplicationMailer

  def survey_invite(user, organizer, survey_invite)
    @user = user
    @organizer = organizer
    @survey_invite = survey_invite
    mail(to: @user.email, subject: "Did you attend \"#{survey_invite.meeting_occurrence.meeting.summary.sub!(/[?.!,;]?$/, '')}\"?")
  end

  def first_answer(participant, meeting_occurrence)
    @participant = participant
    @meeting = meeting_occurrence.meeting
    @meeting_occurrence = meeting_occurrence

    organizer = @meeting.organizer
    mail(to: organizer.email, subject: "The first response is in!")
  end
end
