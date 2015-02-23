module MeetingOccurrenceUtils

  def self.update_repetitions
    meetings = Meeting.where(done: false)
    puts "#{meetings.count}"
    meetings.each do |meeting|
      meeting.update_or_create_nearest_occurrence!
    end
    # meetings = Meeting.past_and_repeating
    # meetings.each do |meeting|
    #   meeting.create_nearest_occurrence!
    # end
  end

end

