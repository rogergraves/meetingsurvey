class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :title
      t.datetime :start_time
      t.datetime :end_time
      t.string :time_zone

      t.timestamps
    end
  end
end
