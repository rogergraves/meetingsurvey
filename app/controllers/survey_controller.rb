class SurveyController < ApplicationController
  before_action :lookup_link_code

  def show
    @questions = Question.all
  end

  def create
    # TODO: add error catching
    invite = SurveyInvite.find_by(link_code: params[:link_code])
    negative_responses = 0

    1.upto(6) do |i|
      negative_responses += 1 if params["answer_#{i}"].to_s.downcase == 'no'

      answer = SurveyAnswer.find_or_initialize_by(user_id: invite.user_id,
                                                  meeting_occurrence: invite.meeting_occurrence,
                                                  question: params["question_#{i}"])
      answer.answer = params["answer_#{i}"]
      answer.why    = params["answer_#{i}_why"]
      answer.save
    end
    @image = (negative_responses > 1 ? 'angry_possum.jpg' : 'possum_family.jpg')

    send_report(invite.user)
  end

  def confirm_attendance
    @survey_invite.update!(confirmed_attendance: true)
    redirect_to survey_path(@survey_invite.link_code)
  end

  def refuse_attendance
    @survey_invite.update!(confirmed_attendance: false)
    @image = 'disgruntled_possum.jpg'
  end

  private

  def lookup_link_code
    @survey_invite = SurveyInvite.find_by(link_code: params[:link_code])
    unless @meeting = @survey_invite.try(:meeting_occurrence).try(:meeting)
      redirect_to home_index_path, :flash => { :alert => "Meeting not found" }
    end
  end

  def send_report(participant)
    occurrence = @survey_invite.meeting_occurrence
    surveyed_users = occurrence.surveyed_users
    refused_users = occurrence.refused_users
    active_participants_count = surveyed_users.count + refused_users.count
    participants_count = occurrence.meeting.participants.count

    if active_participants_count == participants_count
      # TODO: make it delayed job
      SurveyMailer.survey_done(occurrence).deliver_now
      return
    end

    if surveyed_users.count == 1 and surveyed_users.include?(participant)
      # TODO: make it delayed job
      SurveyMailer.first_answer(participant, occurrence).deliver_now
    end
  end

end
