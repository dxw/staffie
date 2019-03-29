# frozen_string_literal: true

require 'slack-ruby-bot'

module Staffie
  module Commands
    class Away < SlackRubyBot::Commands::Base
      scan 'away' do |client, data, _match|
        client.say(
          # TODO: Switch to DMs
          channel: data.channel,
          text: 'TODO'
        )
      end
    end
  end
end
