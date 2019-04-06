# frozen_string_literal: true

root_path = File.join(__dir__, '..')

$LOAD_PATH.unshift(root_path) unless $LOAD_PATH.include?(root_path)

require 'require_all'

require 'slack-ruby-bot/rspec'
require_all 'staffie'
