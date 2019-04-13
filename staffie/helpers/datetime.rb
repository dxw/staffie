# frozen_string_literal: true

require 'chronic'

module Staffie
  module Helpers
    def self.parse_datestring(datestring)
      datetime = Chronic.parse(
        datestring,
        week_start: :monday,
        guess: :begin,
        ambiguous_time_range: 7,
        endian_precedence: %i[little middle]
      )

      raise "Unable to parse #{datestring}" if datetime.nil?

      datetime
    end
  end
end
