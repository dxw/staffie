# frozen_string_literal: true

module Staffie
  module Config
    @scopes = Set.new

    def self.scopes
      @scopes.to_a
    end

    def self.add_scope(scope)
      @scopes.add(scope)
    end
  end
end
