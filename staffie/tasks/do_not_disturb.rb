# frozen_string_literal: true

require 'slack-ruby-client'
require 'staffie/config'
require 'time_difference'

module Staffie
  module Tasks
    Config.add_scope('dnd:write')

    def self.do_not_disturb(user, until_datetime:)
      num_minutes = TimeDifference.between(until_datetime, DateTime.now)
                                  .in_minutes
                                  .ceil

      client = Slack::Web::Client.new(token: user.slack_token)

      client.dnd_setSnooze(num_minutes: num_minutes)
    end
  end
end
