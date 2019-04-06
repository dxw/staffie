# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__) unless $LOAD_PATH.include?(__dir__)

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task default: :spec
rescue LoadError
end

require 'sinatra/activerecord/rake'

namespace :db do
  task :load_config do
    require 'staffie/web'
  end
end
