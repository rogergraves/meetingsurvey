class CreateMeetingOccurrences < ActiveRecord::Migration
  def change
    create_table :meeting_occurrences do |t|
      t.integer :meeting_id
      t.timestamp :start_time
      t.timestamp :end_time

      t.references :meeting

      t.timestamps null: false
    end
  end
end
