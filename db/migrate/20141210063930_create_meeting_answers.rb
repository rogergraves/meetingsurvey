class CreateMeetingAnswers < ActiveRecord::Migration
  def change
    create_table :meeting_answers do |t|
      t.integer :user_id
      t.integer :meeting_id
      t.string :question
      t.string :answer
      t.text :comments

      t.timestamps
    end
  end
end
