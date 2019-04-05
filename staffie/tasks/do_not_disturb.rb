# frozen_string_literal: true

require 'slack-ruby-client'
require 'time_difference'

module Staffie
  module Tasks
    def self.do_not_disturb(until_datetime:)
      # TODO: Pass in a user instead of fetching from ENV.
      client = Slack::Web::Client.new(token: ENV['SLACK_USER_AUTH_TOKEN'])

      num_minutes = TimeDifference.between(until_datetime, DateTime.now)
                                  .in_minutes
                                  .ceil

      client.dnd_setSnooze(num_minutes: num_minutes)
    end
  end
end
