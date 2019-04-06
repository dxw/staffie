# frozen_string_literal: true

require 'sinatra/activerecord'

class SlackEvent < ActiveRecord::Base
  belongs_to :user

  enum event_type: %i[do_not_disturb]

  validates_presence_of :event_type
  validates_presence_of :starts_at
  validates_presence_of :ends_at

  def self.happening_at(datetime)
    where('starts_at <= :datetime and ends_at >= :datetime', datetime: datetime)
  end

  def date_range
    starts_at..ends_at
  end
end
