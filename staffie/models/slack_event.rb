# frozen_string_literal: true

require 'sinatra/activerecord'

class SlackEvent < ActiveRecord::Base
  belongs_to :user

  enum event_type: %i[do_not_disturb]

  validates_presence_of :event_type
  validates_presence_of :starts_at
  validates_presence_of :ends_at

  validate :no_overlap

  def self.happening_at(datetime)
    where('starts_at <= :datetime and ends_at >= :datetime', datetime: datetime)
  end

  def date_range
    starts_at..ends_at
  end

  private

  def no_overlap
    events_of_type_for_user = self.class.where(
      user_id: user_id,
      event_type: event_type
    )

    events_starting_during = events_of_type_for_user.where(
      starts_at: date_range
    )
    events_ending_during = events_of_type_for_user.where(
      ends_at: date_range
    )
    events_covering = events_of_type_for_user.where(
      'starts_at <= :starts_at and ends_at >= :ends_at',
      starts_at: starts_at,
      ends_at: ends_at
    )

    num_overlapping_events = events_starting_during.or(events_ending_during)
                                                   .or(events_covering)
                                                   .count

    if num_overlapping_events.positive?
      errors.add(
        :base,
        'must not overlap existing events of that type for that user'
      )
    end
  end
end
