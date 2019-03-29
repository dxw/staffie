# frozen_string_literal: true

require 'slack-ruby-bot'

module Staffie
  module Commands
    class SetAway < SlackRubyBot::Commands::Base
      command 'set my away status' do |client, data, _match|
        client.say(text: 'TODO', channel: data.channel)
      end
    end
  end
end
