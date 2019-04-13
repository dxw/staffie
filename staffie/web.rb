# frozen_string_literal: true

require 'json'
require 'oauth2'
require 'openssl'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'slack-ruby-client'
require 'staffie/config'
require 'staffie/models/user'
require 'staffie/tasks/delete_slack_event'
require 'staffie/tasks/show_user_slack_events'
require 'time_difference'

module Staffie
  class Web < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    def initialize
      super

      @oauth_client = OAuth2::Client.new(
        ENV['SLACK_CLIENT_ID'], ENV['SLACK_CLIENT_SECRET'],
        site: 'https://slack.com',
        authorize_url: '/oauth/authorize',
        token_url: '/api/oauth.access'
      )

      slack_client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
      test_response = slack_client.auth_test

      @team = test_response.team if test_response.ok
    end

    enable :sessions

    helpers do
      def oauth_redirect_uri
        "#{request.base_url}/oauth/callback"
      end
    end

    get '/' do
      'Woof!'
    end

    get '/authorize' do
      state = SecureRandom.hex(8)
      session[:oauth_state] = state

      redirect @oauth_client.auth_code.authorize_url(
        scope: Config.slack_user_scopes.join(','),
        redirect_uri: oauth_redirect_uri,
        state: state,
        team: @team
      )
    end

    get '/oauth/callback' do
      raise "OAuth error: #{params['error']}" if params['error']

      unless params['state'] == session[:oauth_state]
        raise 'OAuth state didn\'t match'
      end

      token_response = @oauth_client.auth_code.get_token(
        params['code'],
        redirect_uri: oauth_redirect_uri
      )
      token = token_response.token

      client = Slack::Web::Client.new(token: token)

      raise 'OAuth access token invalid' unless client.auth_test.ok

      user_id = token_response.params['user_id']
      user = Models::User.find_by(slack_user_id: user_id)

      if user.nil?
        Models::User.create!(slack_user_id: user_id, slack_token: token)
      elsif user.slack_token != token
        user.update!(slack_token: token)
      end

      'Woof! You\'re authorized! Go back to Slack. Woof!'
    end

    post '/action' do
      return status 403 unless verify_slack_request

      payload = JSON.parse(params[:payload])

      slack_channel_id = payload['channel']['id']
      slack_user_id = payload['user']['id']

      case payload['type']
      when 'block_actions'
        payload['actions'].each do |action|
          case action['value']
          when 'show_user_slack_events'
            user = Models::User.find_by!(slack_user_id: slack_user_id)

            Tasks.show_user_slack_events(user, channel: slack_channel_id)
          when 'delete_slack_event'
            slack_event_id = action['block_id']
            user = Models::User.find_by!(slack_user_id: slack_user_id)

            Tasks.delete_slack_event(slack_event_id, user)
            Tasks.show_user_slack_events(user, channel: slack_channel_id)
          else
            return status 400
          end
        end
      else
        return status 400
      end

      status 204
    end

    private

    # Uses the algorithm from:
    # https://api.slack.com/docs/verifying-requests-from-slack
    def verify_slack_request
      timestamp_header_key = 'HTTP_X_SLACK_REQUEST_TIMESTAMP'
      slack_signature_header_key = 'HTTP_X_SLACK_SIGNATURE'

      has_headers = request.has_header?(timestamp_header_key) &&
                    request.has_header?(slack_signature_header_key)

      return false unless has_headers

      timestamp = request.get_header(timestamp_header_key)
      slack_signature = request.get_header(slack_signature_header_key)

      minutes_since_timestamp =
        TimeDifference.between(DateTime.now, DateTime.strptime(timestamp, '%s'))
                      .in_minutes

      # This may be a replay.
      return false if minutes_since_timestamp.abs > 5

      request.body.rewind
      request_body = request.body.read

      basestring = "v0:#{timestamp}:#{request_body}"

      expected_signature = "v0=#{OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha256'),
        ENV['SLACK_SIGNING_SECRET'],
        basestring
      )}"

      expected_signature == slack_signature
    end
  end
end
