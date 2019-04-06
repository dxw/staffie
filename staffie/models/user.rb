# frozen_string_literal: true

require 'sinatra/activerecord'

class User < ActiveRecord::Base
  validates_presence_of :slack_user_id
  validates_uniqueness_of :slack_user_id, message: 'already exists'
  validate :slack_user_id_is_local

  private

  def slack_user_id_is_local
    unless slack_user_id.starts_with?('U')
      errors.add(:slack_user_id, 'must be locally scoped')
    end
  end
end
