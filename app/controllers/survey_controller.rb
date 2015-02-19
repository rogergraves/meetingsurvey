class SurveyController < ApplicationController
  before_action :lookup_link_code, only: [:show, :create]
  before_action :set_survey_invite, only: [:confirm_attendance, :refuse_attendance]

  def show
    @questions = [
        { question: "Was the meeting relevant to you?", type: :yes_or_no },
        { question: "Was the purpose of the meeting clear?", type: :yes_or_no },
        { question: "Did the meeting have the right people?", type: :yes_or_no },
        { question: "Did the meeting have good communication?", type: :yes_or_no },
        { question: "Were there clear takeaways or action items?", type: :yes_or_no },
        { question: "Please leave any other feedback", type: :text },
    ]
  end

  def create
    # TODO: add error catching
    invite = SurveyInvite.find_by(link_code: params[:link_code])

    1.upto(6) do |i|
      SurveyAnswer.create( user_id: invite.user_id,
                            meeting_occurrence_id: invite.meeting_occurrence.id,
                            question: params["question_#{i}"],
                            answer: params["answer_#{i}"]
      )
    end


    render text: 'Thank you!'
  end

  def confirm_attendance
    @survey_invite.update!(confirmed_attendance: true)
    redirect_to survey_path(@survey_invite.link_code)
  end

  def refuse_attendance
    @survey_invite.update!(confirmed_attendance: false)
    render text: 'Thank you!'
  end

  private

  def lookup_link_code
    unless @meeting = Meeting.lookup(params[:link_code])
      redirect_to home_index_path, :flash => { :alert => "Meeting not found" }
    end
  end

  def set_survey_invite
    @survey_invite = SurveyInvite.find_by(link_code: params[:link_code])
  end
end
