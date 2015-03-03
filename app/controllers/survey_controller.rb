class SurveyController < ApplicationController
  before_action :lookup_link_code

  def show
    @questions = [
        { question: "Was this meeting relevant to you?", type: :yes_or_no },
        { question: "Was the purpose of this meeting clear?", type: :yes_or_no },
        { question: "Did this meeting have the right people?", type: :yes_or_no },
        { question: "Did this meeting hanve good communication?", type: :yes_or_no },
        { question: "Were there clear takeaways or action items?", type: :yes_or_no },
        { question: "Any other feedback?", type: :text },
    ]
  end

  def create
    # TODO: add error catching
    invite = SurveyInvite.find_by(link_code: params[:link_code])
    negative_responses = 0

    1.upto(6) do |i|
      negative_responses += 1 if params["answer_#{i}"].to_s.downcase == 'no'

      SurveyAnswer.create( user_id: invite.user_id,
                            meeting_occurrence_id: invite.meeting_occurrence.id,
                            question: params["question_#{i}"],
                            answer: params["answer_#{i}"],
                            why: params["answer_#{i}_why"]
      )
    end
    @image = (negative_responses > 1 ? 'angry_possum.jpg' : 'possum_family.jpg')
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

end
