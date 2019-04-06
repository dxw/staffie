# frozen_string_literal: true

require 'sidekiq'

require 'staffie/models/user'
require 'staffie/tasks/do_not_disturb'

module Staffie
  module Jobs
    class DoNotDisturb
      include Sidekiq::Worker

      def perform(user_id)
        user = User.find(user_id)

        Staffie::Tasks.do_not_disturb(user)
      end
    end
  end
end
