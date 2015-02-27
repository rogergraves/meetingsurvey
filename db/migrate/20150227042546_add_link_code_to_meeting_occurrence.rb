class AddLinkCodeToMeetingOccurrence < ActiveRecord::Migration
  def change
    add_column :meeting_occurrences, :link_code, :string
    add_index :meeting_occurrences, :link_code
  end
end
