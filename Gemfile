# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'async-websocket'
gem 'dotenv'
gem 'puma'
gem 'slack-ruby-bot'
gem 'slack-ruby-client'
gem 'sinatra'
gem 'time_difference'

group :development, :test do
  gem 'rake'
  gem 'foreman'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'vcr'
  gem 'webmock'
end
