class CreateMeetingParticipations < ActiveRecord::Migration
  def change
    create_table :meeting_participations do |t|
      t.integer :user_id
      t.integer :meeting_id
      t.boolean :organizer
      t.boolean :confirmed_attendance
      t.references :user, index: true
      t.references :meeting, index: true

      t.timestamps
    end
  end
end
