# frozen_string_literal: true

class CreateSlackEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :slack_events do |t|
      t.belongs_to :user, index: true

      t.integer :event_type, index: true
      t.datetime :starts_at, index: true
      t.datetime :ends_at, index: true

      t.timestamps
    end
  end
end
