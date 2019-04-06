# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__) unless $LOAD_PATH.include?(__dir__)

require 'dotenv'
Dotenv.load

require 'staffie'

Thread.abort_on_exception = true

Thread.new do
  Staffie::Bot.run
rescue Exception => e
  STDERR.puts "ERROR: #{e}"
  STDERR.puts e.backtrace
  raise e
end

run Staffie::Web
