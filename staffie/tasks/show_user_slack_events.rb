# frozen_string_literal: true

require 'slack-ruby-client'

module Staffie
  module Tasks
    SHOW_USER_SLACK_EVENTS_PREFIX_BLOCKS = [
      {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: 'Woof! I have the following events scheduled for you.'
        }
      },
      {
        type: 'divider'
      }
    ].freeze

    SHOW_USER_SLACK_EVENTS_SUFFIX_BLOCKS = [
      {
        type: 'divider'
      },
      {
        type: 'actions',
        elements: [
          {
            type: 'button',
            text: {
              type: 'plain_text',
              text: 'More'
            },
            value: 'show_more_user_slack_events'
          },
          {
            type: 'button',
            text: {
              type: 'plain_text',
              text: 'Add event'
            },
            value: 'new_do_not_disturb_event'
          }
        ]
      }
    ].freeze

    SHOW_USER_SLACK_EVENTS_NO_DATA_BLOCKS = [
      {
        type: 'section',
        text: {
          type: 'plain_text',
          text: 'Woof! Looks like you don\'t have any events coming up.'
        }
      },
      {
        type: 'actions',
        elements: [
          {
            type: 'button',
            text: {
              type: 'plain_text',
              text: 'Add event'
            },
            value: 'new_do_not_disturb_event'
          }
        ]
      }
    ].freeze

    def self.show_user_slack_events(user, channel: nil)
      channel ||= user.slack_user_id
      slack_events = user.slack_events
                         .select(%i[id event_type starts_at ends_at])
                         .where('ends_at > :now', now: DateTime.now)
                         .order(:starts_at)
                         .limit(20)
                         .to_a

      blocks = if slack_events.count.positive?
                 [
                   SHOW_USER_SLACK_EVENTS_PREFIX_BLOCKS,
                   show_user_slack_event_blocks(slack_events),
                   SHOW_USER_SLACK_EVENTS_SUFFIX_BLOCKS
                 ].flatten(1)
               else
                 SHOW_USER_SLACK_EVENTS_NO_DATA_BLOCKS
               end

      client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
      response = client.chat_postEphemeral(
        channel: channel,
        user: user.slack_user_id,
        as_user: true,
        blocks: blocks
      )

      raise "Slack error: #{response.error}" unless response.ok
    end

    def self.show_user_slack_event_blocks(slack_events)
      slack_events.map do |event|
        emoji = case event.event_type
                when 'do_not_disturb'
                  ':shushing_face:'
                else
                  ':calendar:'
                end

        {
          type: 'section',
          block_id: event.id.to_s,
          text: {
            type: 'mrkdwn',
            text: "#{emoji} #{event.humanized_starts_at} to #{event.humanized_ends_at}"
          },
          accessory: {
            type: 'button',
            text: {
              type: 'plain_text',
              text: 'Delete'
            },
            value: 'delete_slack_event'
          }
        }
      end
    end
  end
end
