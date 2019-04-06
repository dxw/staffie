# frozen_string_literal: true

require 'sinatra/activerecord'

class SlackEvent < ActiveRecord::Base
  belongs_to :user

  enum event_type: %i[do_not_disturb]

  validates_presence_of :event_type
  validates_presence_of :starts_at
  validates_presence_of :ends_at
end
