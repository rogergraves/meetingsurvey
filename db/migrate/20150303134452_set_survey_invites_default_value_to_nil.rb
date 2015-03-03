class SetSurveyInvitesDefaultValueToNil < ActiveRecord::Migration
  def change
    change_column :survey_invites, :confirmed_attendance, :boolean, default: nil
  end
end
