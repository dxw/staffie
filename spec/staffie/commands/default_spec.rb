# frozen_string_literal: true

require 'spec_helper'

describe Staffie::Commands::Default do
  def app
    Staffie::Bot.instance
  end

  subject { app }

  it 'returns a woof' do
    expect(
      message: "#{SlackRubyBot.config.user} some nonsense",
      channel: 'channel'
    ).to respond_with_slack_message(':dog: Woof! :dog:')
  end
end
