# frozen_string_literal: true

require 'spec_helper'

describe Staffie::Commands::Away do
  def app
    Staffie::Bot.instance
  end

  subject { app }

  it 'returns TODO' do
    expect(
      message: "#{SlackRubyBot.config.user} set my away status",
      channel: 'channel'
    ).to respond_with_slack_message('TODO')
  end
end
