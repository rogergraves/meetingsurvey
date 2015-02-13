class SurveyController < ApplicationController
  before_action :lookup_link_code, only: [:show]

  def show

  end

  def create
    # TODO: add error catching
    participant = MeetingParticipation.find_by(link_code: params[:link_code])
    meeting = Meeting.lookup(params[:link_code])

    1.upto(6) do |i|
      MeetingAnswer.create( user_id: participant.user_id,
                            meeting_id: meeting.id,
                            question: params["question_#{i}"],
                            answer: params["answer_#{i}"]
      )
    end


    render text: "Thank You!"
    # render text: "qwe #{participant.link_code}"
  end

  private

  def lookup_link_code
    unless @meeting = Meeting.lookup(params[:link_code])
      redirect_to home_index_path, :flash => { :alert => "Meeting not found" }
    end
  end
end
