# frozen_string_literal: true

require 'staffie/models/slack_event'

module Staffie
  module Tasks
    def self.schedule_slack_event(event_type, user, starts_at:, ends_at:)
      Models::SlackEvent.create!(
        user: user,
        event_type: event_type,
        starts_at: starts_at,
        ends_at: ends_at
      )
    end
  end
end
