# frozen_string_literal: true

require 'slack-ruby-bot'

module Staffie
  module Commands
    class Away < SlackRubyBot::Commands::Base
      scan 'away' do |client, data, _match|
        client.web_client.chat_postMessage(
          # TODO: Switch to DMs
          channel: data.channel,
          as_user: true,
          attachments: [
            {
              text: 'What do you want to do? Woof!',
              attachment_type: 'default',
              actions: [
                {
                  name: 'away_action',
                  text: 'Add away date',
                  type: 'button',
                  value: 'new',
                  style: 'primary'
                },
                {
                  name: 'away_action',
                  text: 'Show away dates',
                  type: 'button',
                  value: 'show'
                },
                {
                  name: 'away_action',
                  text: 'Cancel',
                  type: 'button',
                  value: 'cancel',
                  style: 'danger'
                }
              ]
            }
          ]
        )
      end
    end
  end
end
