class CreateMeetingUsers < ActiveRecord::Migration
  def change
    create_table :meeting_users do |t|
      t.references :user, index: true
      t.references :meeting, index: true
      t.boolean :organizer

      t.timestamps null: false
    end
    add_foreign_key :meeting_users, :users
    add_foreign_key :meeting_users, :meetings
  end
end
