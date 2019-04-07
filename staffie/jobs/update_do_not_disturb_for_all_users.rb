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
        slack_events_to_process.each do |event|
          Staffie::Tasks.do_not_disturb(event.user, ends_at: event.ends_at)
        end
      end

      private

      def slack_events_to_process
        now = DateTime.now
        client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])

        batched_events_to_process =
          SlackEvent.happening_at(now)
                    .where(event_type: :do_not_disturb)
                    .includes(:user)
                    .each_slice(50)
                    .map do |events|
            # There should only be one event per user, but if there were more,
            # this would be made more efficient by grouping by user (and maybe
            # only considering the earliest event).
            ids = events.map { |event| event.user.slack_user_id }

            response = client.dnd_teamInfo(users: ids.join(','))

            events.select do |event|
              dnd_status = response.users[event.user.slack_user_id]

              next true unless dnd_status.dnd_enabled

              dnd_has_started = DateTime.strptime(
                dnd_status.next_dnd_start_ts.to_s, '%s'
              ) <= now

              next true unless dnd_has_started

              dnd_ends_before_event = event.date_range.cover?(
                DateTime.strptime(dnd_status.next_dnd_end_ts.to_s, '%s')
              )

              dnd_ends_before_event
            end
          end

        batched_events_to_process.flatten
      end
    end
  end
end

Sidekiq::Cron::Job.create(
  name: 'Staffie::Jobs::UpdateDoNotDisturbForAllUsers at xx:00 and xx:30',
  cron: '00,30 * * * *',
  class: 'Staffie::Jobs::UpdateDoNotDisturbForAllUsers'
)
