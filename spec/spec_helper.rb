# frozen_string_literal: true

root_path = File.join(__dir__, '..')

$LOAD_PATH.unshift(root_path) unless $LOAD_PATH.include?(root_path)

require 'slack-ruby-bot/rspec'
require 'staffie'
