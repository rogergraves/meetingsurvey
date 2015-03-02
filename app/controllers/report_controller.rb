class ReportController < ApplicationController
  before_action :lookup_link_code

  def show
  end

  private

  def lookup_link_code
    @meeting_occurrence = MeetingOccurrence.find_by(link_code: params[:id])
    unless @meeting = @meeting_occurrence.try(:meeting)
      redirect_to home_index_path, :flash => { :alert => "Meeting not found" }
    end
  end
end
