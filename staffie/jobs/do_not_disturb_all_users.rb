# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq-cron'

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

Sidekiq::Cron::Job.create(
  name: 'Staffie::Jobs::DoNotDisturbAllUsers at xx:00 and xx:30',
  cron: '00,30 * * * *',
  class: 'Staffie::Jobs::DoNotDisturbAllUsers'
)
