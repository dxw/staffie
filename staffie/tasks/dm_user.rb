# frozen_string_literal: true

require 'slack-ruby-client'

module Staffie
  module Tasks
    def self.dm_user(user, message:, woof: true)
      text = message.strip
      text += ' Woof!' if message && woof

      client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
      response = client.chat_postMessage(
        channel: user.slack_user_id,
        as_user: true,
        text: text.strip
      )

      raise "Slack error: #{response.error}" unless response.ok
    end
  end
end