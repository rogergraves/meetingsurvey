class AddDoneColumnToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :done, :boolean, default: false
  end
end
