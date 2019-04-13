# frozen_string_literal: true

require 'staffie/models/slack_event'

module Staffie
  module Tasks
    def self.delete_slack_event(id, user)
      slack_event = Models::SlackEvent.find_by!(id: id, user: user)

      slack_event.destroy!

      return unless slack_event.date_range.cover?(DateTime.now)

      client = Slack::Web::Client.new(token: user.slack_token)
      response = client.dnd_endSnooze

      raise "Slack error: #{response.error}" unless response.ok
    end
  end
end
