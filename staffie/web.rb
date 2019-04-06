# frozen_string_literal: true

require 'oauth2'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'slack-ruby-client'
require 'staffie/config'
require 'staffie/models/user'

module Staffie
  class Web < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    def initialize
      super

      @oauth_client = OAuth2::Client.new(
        ENV['SLACK_CLIENT_ID'],
        ENV['SLACK_CLIENT_SECRET'],
        site: 'https://slack.com',
        authorize_url: '/oauth/authorize',
        token_url: '/api/oauth.access'
      )
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
        scope: Config.scopes.join(', '),
        redirect_uri: oauth_redirect_uri,
        state: state,
        team: params['team']
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
      user = User.find_by(slack_user_id: user_id)

      if user.nil?
        User.create!(slack_user_id: user_id, slack_token: token)
      elsif user.slack_token != token
        user.update!(slack_token: token)
      end

      'Woof! You\'re authorized! Go back to Slack. Woof!'
    end
  end
end
