class AddFieldsToMeetings < ActiveRecord::Migration
  def change
    remove_column :meetings, :time_zone
    rename_column :meetings, :title, :summary

    add_column :meetings, :description,  :string
    add_column :meetings, :created_time, :datetime
    add_column :meetings, :location,     :string
    add_column :meetings, :status,       :string
    add_column :meetings, :uid,          :string
    add_column :meetings, :repeat_rule,  :hstore

    add_index :meetings, :uid, unique: true
  end
end
