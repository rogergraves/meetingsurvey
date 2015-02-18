class AddSurveyInviteTable < ActiveRecord::Migration
  def change
    create_table :survey_invites do |t|
      t.integer :user_id
      t.integer :meeting_occurrence_id
      t.boolean :confirmed_attendance, default: false
      t.datetime :email_sent
      t.string :link_code

      t.timestamps
    end
  end
end
