# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__) unless $LOAD_PATH.include?(__dir__)

require 'dotenv'
Dotenv.load

require 'require_all'

require 'sidekiq/web'
require 'sidekiq/cron/web'

require_all 'staffie'

run Rack::URLMap.new('/' => Staffie::Web, '/sidekiq' => Sidekiq::Web)
