# frozen_string_literal: true

require 'slack-ruby-client'

module Staffie
  module Tasks
    def self.dm_user(user, blocks: nil, message: nil, woof: true)
      raise 'Must provide message or blocks' if message.nil? && blocks.nil?

      post_message_options = {
        channel: user.slack_user_id,
        as_user: true
      }

      unless message.nil?
        text = message.strip
        text += ' Woof!' if message && woof

        post_message_options[:text] = text.strip
      end

      post_message_options[:blocks] = blocks unless blocks.nil?

      client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
      response = client.chat_postMessage(post_message_options)

      raise "Slack error: #{response.error}" unless response.ok
    end
  end
end
