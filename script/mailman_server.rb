#!/usr/bin/env ruby

require "rubygems"
require "icalendar"
require "bundler/setup"
require "mailman"


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

Mailman::Application.run do
  default do
    message.attachments.each do |attachment|
      if /application\/ics/ =~ attachment.content_type
        cals = Icalendar.parse(attachment.body)
        cal = cals.first
        event = cal.events.first
        # Meeting.create!(title: event.summary.to_s,
        #                 start_time: event.dtstart.to_s,
        #                 end_time: event.dtend.to_s
        # )
        puts "summary: #{event.summary}"
        puts "description: #{event.description}"
        puts "dtstart: #{event.dtstart}"
        puts "dtend: #{event.dtend}"
        puts "created: #{event.created}"
        puts "last_modified: #{event.last_modified}"
        puts "location: #{event.location}"
        puts "organizer: #{event.organizer}"
        puts "sequence: #{event.sequence}"
        puts "status: #{event.status}"
        puts "recurrence_id: #{event.recurrence_id}"
        puts "rrule: #{event.rrule}" # Frequency, i.e. [#<OpenStruct frequency="WEEKLY", until=nil, count=nil, interval=nil, by_second=nil, by_minute=nil, by_hour=nil, by_day=["MO"], by_month_day=nil, by_year_day=nil, by_week_number=nil, by_month=nil, by_set_position=nil, week_start=nil>]
        puts "attendee: #{event.attendee}"
      end
    end
  end
end