# frozen_string_literal: true

require 'slack-ruby-bot'

module Staffie
  module Commands
    class Default < SlackRubyBot::Commands::Base
      command 'default', /.*/ do |client, data, _match|
        client.say(
          channel: data.channel,
          text: ':dog: Woof! :dog:'
        )
      end
    end
  end
end
