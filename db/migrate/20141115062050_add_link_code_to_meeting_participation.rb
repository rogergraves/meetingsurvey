class AddLinkCodeToMeetingParticipation < ActiveRecord::Migration
  def change
    add_column :meeting_participations, :link_code, :string
  end
end
