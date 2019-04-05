# frozen_string_literal: true

require 'oauth2'
require 'sinatra/base'
require 'slack-ruby-client'
require 'staffie/config'

module Staffie
  class Web < Sinatra::Base
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

      access_token = @oauth_client.auth_code.get_token(
        params['code'],
        redirect_uri: oauth_redirect_uri
      )

      token = access_token.token
      client = Slack::Web::Client.new(token: token)

      raise 'OAuth access token invalid' unless client.auth_test.ok

      puts token # TODO: Attach this to a user.

      'Woof! You\'re authorized! Go back to Slack. Woof!'
    end
  end
end
