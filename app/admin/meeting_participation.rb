ActiveAdmin.register MeetingParticipation do

  permit_params :user_id, :meeting_id, :organizer, :confirmed_attendance, :link_code

  form do |f|
    f.inputs "Meeting Participation Fields" do
      f.input :user
      f.input :meeting
      f.input :organizer
      f.input :confirmed_attendance
      f.input :link_code, :label => "Link code (leave blank to auto generate)"
    end
    f.actions
  end

end
