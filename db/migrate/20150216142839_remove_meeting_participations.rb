class RemoveMeetingParticipations < ActiveRecord::Migration
  def change
    drop_table :meeting_participations
  end
end
