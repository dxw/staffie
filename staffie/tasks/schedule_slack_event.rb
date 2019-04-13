# frozen_string_literal: true

require 'staffie/helpers/datetime'
require 'staffie/models/slack_event'

module Staffie
  module Tasks
    def self.schedule_slack_event(event_type, user, starts_at:, ends_at:)
      starts_at_datetime = Helpers.parse_datestring(starts_at.to_s)
      ends_at_datetime = Helpers.parse_datestring(ends_at.to_s)

      raise 'Event ends before start' if ends_at_datetime < starts_at_datetime
      raise 'Event ends in the past' if ends_at_datetime < DateTime.now

      Models::SlackEvent.create!(
        user: user,
        event_type: event_type,
        starts_at: starts_at_datetime,
        ends_at: ends_at_datetime
      )
    end
  end
end
