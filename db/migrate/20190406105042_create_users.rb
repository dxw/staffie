# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :slack_user_id
      t.string :slack_token

      t.timestamps
    end
  end
end
