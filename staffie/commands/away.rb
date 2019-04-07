# frozen_string_literal: true

require 'slack-ruby-bot'

module Staffie
  module Commands
    class Away < SlackRubyBot::Commands::Base
      BLOCKS = [
        {
          type: 'section',
          text: {
            type: 'plain_text',
            text: 'What do you want to do? Woof!'
          }
        },
        {
          type: 'actions',
          elements: [
            {
              type: 'button',
              text: {
                type: 'plain_text',
                text: 'Add event'
              },
              value: 'new_do_not_disturb_event'
            },
            {
              type: 'button',
              text: {
                type: 'plain_text',
                text: 'Show scheduled events'
              },
              value: 'show_user_slack_events'
            }
          ]
        }
      ].freeze

      scan 'away' do |client, data, _match|
        client.web_client.chat_postEphemeral(
          channel: data.channel,
          user: data.user,
          as_user: true,
          blocks: BLOCKS
        )
      end
    end
  end
end
