require "icalendar"
require "mailman"
require 'figaro'

module EmailChecker
  DEFAULT_PASSWORD = '1234567890'

  Mailman.config.imap = {
      server: 'imap.gmail.com',
      port: 993,  # usually 995, 993 for gmail
      ssl: true,
      domain: (ENV['MAILMAN_DOMAIN'] || 'rubyriders.com'),
      username: (ENV['MAILMAN_USERNAME'] || 'meetingsurvey@rubyriders.com'),
      password: (ENV['MAILMAN_PASSWORD'] || '@fLJS3!@ds')
  }

  # Mailman.config.ignore_stdin = true
  Mailman.config.poll_interval = 0
  # Mailman.config.maildir = '~/Maildir'

  def self.run
    Mailman::Application.run do
      default do
        EmailChecker.process_message(message)
      end
    end
  end

  def self.process_message(message)
    message.attachments.each do |attachment|
      if /application\/ics/ =~ attachment.content_type
        cals = Icalendar.parse(attachment.body)
        cal = cals.first
        event = cal.events.first

        # Add meeting
        meeting = Meeting.find_or_initialize_by(uid: event.uid.to_s)

        meeting.summary       = event.summary.to_s
        meeting.description   = event.description.to_s
        meeting.start_time    = event.dtstart.to_s
        meeting.end_time      = event.dtend.to_s
        meeting.created_time  = event.created.to_s
        meeting.location      = event.location.to_s
        meeting.status        = event.status.to_s

        if event.rrule.first
          rule = {}
          event_rule = event.rrule.first
          rule[:frequency]        = event_rule.frequency
          rule[:until]            = event_rule.until
          rule[:count]            = event_rule.count
          rule[:interval]         = event_rule.interval
          rule[:by_second]        = event_rule.by_second
          rule[:by_minute]        = event_rule.by_minute
          rule[:by_hour]          = event_rule.by_hour
          rule[:by_day]           = event_rule.by_day
          rule[:by_month_day]     = event_rule.by_month_day
          rule[:by_year_day]      = event_rule.by_year_day
          rule[:by_week_number]   = event_rule.by_week_number
          rule[:by_month]         = event_rule.by_month
          rule[:by_set_position]  = event_rule.by_set_position
          rule[:week_start]       = event_rule.week_start

          meeting.repeat_rule = rule
        end

        meeting.save!

        # Add participations
        ## Organizer
        meeting_occurrence = meeting.meeting_occurrences.first
        organizer_email = event.organizer.to_s.split(':').last
        organizer_user = User.find_or_create_by!(email: organizer_email) do |user|
          user.password = DEFAULT_PASSWORD
        end
        SurveyInvite.find_or_create_by!(meeting_occurrence: meeting_occurrence, user: organizer_user)

        ## Attendees
        attendee_emails = event.attendee.map(&:to)
        attendee_emails.delete(organizer_email)
        attendee_users =  attendee_emails.map do |email|
          User.find_or_create_by!(email: email) do |user|
            user.password = DEFAULT_PASSWORD
          end
        end
        SurveyInvite.where(meeting_occurrence: meeting_occurrence).where.not(user: attendee_users).delete_all
        attendee_users.each do |user|
          SurveyInvite.find_or_create_by!(meeting_occurrence: meeting_occurrence, user: user)
        end

        # puts "summary: #{event.summary}"
        # puts "description: #{event.description}"
        # puts "dtstart: #{event.dtstart}"
        # puts "dtend: #{event.dtend}"
        # puts "created: #{event.created}"
        # puts "last_modified: #{event.last_modified}"
        # puts "location: #{event.location}"
        # puts "organizer: #{event.organizer}"
        # puts "sequence: #{event.sequence}"
        # puts "status: #{event.status}"
        # puts "recurrence_id: #{event.recurrence_id}"
        # puts "rrule: #{event.rrule}" # Frequency, i.e. [#<OpenStruct frequency="WEEKLY", until=nil, count=nil, interval=nil, by_second=nil, by_minute=nil, by_hour=nil, by_day=["MO"], by_month_day=nil, by_year_day=nil, by_week_number=nil, by_month=nil, by_set_position=nil, week_start=nil>]
        # puts "attendee: #{event.attendee}"
      end
    end
  end


end