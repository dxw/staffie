web: bundle exec puma -p $PORT --log-requests
bot: ruby ./bot.rb
jobs: bundle exec sidekiq -r ./jobs.rb
