# frozen_string_literal: true

require 'sidekiq'
require 'staffie/models/user'
require 'staffie/tasks/do_not_disturb'

module Staffie
  module Jobs
    class DoNotDisturbAllUsers
      include Sidekiq::Worker

      def perform
        User.all.each do |user|
          Staffie::Tasks.do_not_disturb(user)
        end
      end
    end
  end
end
