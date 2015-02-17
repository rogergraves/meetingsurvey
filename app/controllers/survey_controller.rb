class SurveyController < ApplicationController
  before_action :lookup_link_code

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


    render text: "Thank You!"
  end

  private

  def lookup_link_code
    unless @meeting = Meeting.lookup(params[:link_code])
      redirect_to home_index_path, :flash => { :alert => "Meeting not found" }
    end
  end
end
