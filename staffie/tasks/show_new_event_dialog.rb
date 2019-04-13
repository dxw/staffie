# frozen_string_literal: true

require 'slack-ruby-client'

module Staffie
  module Tasks
    time_options = []

    24.times do |i|
      hour = i.to_s.rjust(2, '0')

      2.times do |j|
        minutes = (30 * j).to_s.rjust(2, '0')
        time = "#{hour}:#{minutes}"

        time_options.push(label: time, value: time)
      end
    end

    SHOW_NEW_EVENT_DIALOG_BLOCK = {
      title: 'New event',
      callback_id: 'new_event_dialog',
      elements: [
        {
          type: 'text',
          label: 'Start date',
          name: 'starts_at_date'
        },
        {
          type: 'select',
          label: 'Start time',
          name: 'starts_at_time',
          options: time_options
        },
        {
          type: 'text',
          label: 'End date',
          name: 'ends_at_date'
        },
        {
          type: 'select',
          label: 'End time',
          name: 'ends_at_time',
          options: time_options
        }
      ]
    }.freeze

    def self.show_new_event_dialog(trigger_id:)
      client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
      response = client.dialog_open(
        trigger_id: trigger_id,
        dialog: SHOW_NEW_EVENT_DIALOG_BLOCK
      )

      raise "Slack error: #{response.error}" unless response.ok
    end
  end
end
