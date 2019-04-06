# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__) unless $LOAD_PATH.include?(__dir__)

require 'dotenv'
Dotenv.load

require 'require_all'

require_all 'staffie'
