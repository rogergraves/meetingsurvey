ActiveAdmin.register Meeting do

  permit_params :title, :start_time, :end_time, :time_zone

  index :download_links => true do
    column :summary
    column :description
    column :start_time
    column :end_time
    column :location
    column :status
    column "Organizer" do |meeting|
      meeting.organizer.email
    end
    column "Participants" do |meeting|
      meeting.participants.pluck(:email).join(', ')
    end
    column :repeat_rule

    actions
  end

  show do |meeting|
    attributes_table do
      row :id
      row :summary
      row :description
      row :start_time
      row :end_time
      row :location
      row :status
      row "Meeting Occurrences" do
        meeting.meeting_occurrences.map{|occurrence| "#{occurrence.end_time}#{occurrence.occurred? ? ' (done)' : ''}" }.join(', ')
      end

    end

  end

end
