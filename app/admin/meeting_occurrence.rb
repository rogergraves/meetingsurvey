ActiveAdmin.register MeetingOccurrence do

  permit_params :title, :start_time, :end_time, :time_zone

  index :download_links => true do
    column "Meeting Summary" do |occurrence|
      occurrence.meeting.summary
    end
    column :end_time
    column :occurred
    column "Results" do |occurrence|
      link_to("report", "/report/#{occurrence.link_code}", :target => "_new")
    end

    actions
  end

end
