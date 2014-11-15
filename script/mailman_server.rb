#!/usr/bin/env ruby

require "rubygems"
require "ics"
require "bundler/setup"
require "mailman"
require "awesome_print"


Mailman.config.imap = {
    server: 'imap.gmail.com',
    port: 993,  # usually 995, 993 for gmail
    ssl: true,
    domain: (ENV['MAILMAN_DOMAIN'] || 'rubyriders.com'),
    username: (ENV['MAILMAN_USERNAME'] || 'meetingsurvey@rubyriders.com'),
    password: (ENV['MAILMAN_PASSWORD'] || '@fLJS3!@ds')
}

Mailman.config.poll_interval = 0

Mailman::Application.run do
    default do
        begin
            puts "Received new message! '#{message.subject}'"
            if message.attachments.count > 0
                events = ICS::Event.file(message.attachments[0])
                puts "!!!!!!!!!!!!!!!!!!!!! Start of attachment"
                print events.ai
                puts "!!!!!!!!!!!!!!!!!!!!! End of attachment"
            end
        rescue Exception => e
            Mailman.logger.error "Exception occured while receiving message:\n#{message}"
            Mailman.logger.error [e, *e.backtrace].join("\n")
        end
    end
end