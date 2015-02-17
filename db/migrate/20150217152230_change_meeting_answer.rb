class ChangeMeetingAnswer < ActiveRecord::Migration
  def change
    rename_table :meeting_answers, :survey_answers

    remove_column :survey_answers, :meeting_id
    add_reference :survey_answers, :meeting_occurrence
    rename_column :survey_answers, :comments, :why
  end
end
