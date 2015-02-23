class AddOccurredColumnToMeetingOccurrences < ActiveRecord::Migration
  def change
    add_column :meeting_occurrences, :occurred, :boolean, default: false
  end
end
