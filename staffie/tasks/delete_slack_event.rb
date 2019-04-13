# frozen_string_literal: true

require 'staffie/models/slack_event'

module Staffie
  module Tasks
    def self.delete_slack_event(id, user)
      slack_event = Models::SlackEvent.find_by!(id: id, user: user)

      slack_event.destroy!
    end
  end
end
