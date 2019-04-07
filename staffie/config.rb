# frozen_string_literal: true

module Staffie
  module Config
    @slack_user_scopes = Set.new

    def self.slack_user_scopes
      @slack_user_scopes.to_a
    end

    def self.add_slack_user_scope(scope)
      @slack_user_scopes.add(scope)
    end
  end
end
