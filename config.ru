# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'dotenv'
Dotenv.load

require 'staffie'
require 'web'

Thread.abort_on_exception = true

Thread.new do
  Staffie::Bot.run
rescue Exception => e
  STDERR.puts "ERROR: #{e}"
  STDERR.puts e.backtrace
  raise e
end

run Staffie::Web
