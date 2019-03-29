# frozen_string_literal: true

require 'sinatra/base'

module Staffie
  class Web < Sinatra::Base
    get '/' do
      'Woof!'
    end
  end
end
