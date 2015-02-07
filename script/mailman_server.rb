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
        # TODO: add time_zone
        Meeting.create!(title: event.summary.to_s,
                        start_time: event.dtstart.to_s,
                        end_time: event.dtend.to_s
        )
        # puts "summary: #{event.summary}"
        # puts "description: #{event.description}"
        # puts "dtstart: #{event.dtstart}"
        # puts "dtend: #{event.dtend}"
      end
    end
  end
end