class SurveyController < ApplicationController
  before_action :lookup_link_code

  def index

  end

  def create
  end

  private

  def lookup_link_code
    unless @meeting = Meeting.lookup(params[:link_code])
      redirect_to home_index_path, :flash => { :alert => "Meeting not found" }
    end
  end
end
