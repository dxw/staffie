# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq-cron'

require 'staffie/models/slack_event'
require 'staffie/tasks/do_not_disturb'

module Staffie
  module Jobs
    class UpdateDoNotDisturbForAllUsers
      include Sidekiq::Worker

      def perform
        from_now_on = DateTime.now..DateTime::Infinity.new

        SlackEvent.where(event_type: :do_not_disturb, ends_at: from_now_on)
                  .each do |slack_event|
          starts_at = slack_event.starts_at
          ends_at = slack_event.ends_at

          next unless (starts_at..ends_at).cover?(DateTime.now)

          Staffie::Tasks.do_not_disturb(
            slack_event.user,
            ends_at: ends_at
          )
        end
      end
    end
  end
end

Sidekiq::Cron::Job.create(
  name: 'Staffie::Jobs::UpdateDoNotDisturbForAllUsers at xx:00 and xx:30',
  cron: '00,30 * * * *',
  class: 'Staffie::Jobs::UpdateDoNotDisturbForAllUsers'
)
