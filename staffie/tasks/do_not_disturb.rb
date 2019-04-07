# frozen_string_literal: true

require 'slack-ruby-client'
require 'staffie/config'
require 'time_difference'

module Staffie
  module Tasks
    Config.add_slack_user_scope('dnd:write')

    def self.do_not_disturb(user, ends_at:)
      num_minutes = TimeDifference.between(ends_at, DateTime.now)
                                  .in_minutes
                                  .ceil

      client = Slack::Web::Client.new(token: user.slack_token)
      response = client.dnd_setSnooze(num_minutes: num_minutes)

      raise "Slack error: #{response.error}" unless response.ok
    end
  end
end
