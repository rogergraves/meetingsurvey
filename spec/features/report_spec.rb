require "rails_helper"

feature "Report interaction" do

  scenario "I see error page when :link_code is invalid", js: true do
    @link_code = '1234567890'

    given_a_meeting_occurrence
    and_i_visit_wrong_report_page
    then_i_see_error_page
  end

  def given_a_meeting_occurrence
    meeting = create(:meeting)
    meeting_occurrence = meeting.meeting_occurrences.take
    meeting_occurrence.update(link_code: @link_code)
    expect(MeetingOccurrence.find_by(link_code: @link_code))
  end

  def and_i_visit_wrong_report_page
    visit '/report/wrong_id'
  end

  def then_i_see_error_page
    expect(page).to have_content('Meeting not found')
  end
end