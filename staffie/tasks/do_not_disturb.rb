# frozen_string_literal: true

require 'slack-ruby-client'
require 'staffie/config'
require 'time_difference'

module Staffie
  module Tasks
    Config.add_scope('dnd:write')

    def self.do_not_disturb(user)
      end_datetime = 1.hour.from_now
      num_minutes = TimeDifference.between(end_datetime, DateTime.now)
                                  .in_minutes
                                  .ceil

      client = Slack::Web::Client.new(token: user.slack_token)

      client.dnd_setSnooze(num_minutes: num_minutes)
    end
  end
end
