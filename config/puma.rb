workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 10)
threads threads_count, threads_count

#rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

stdout_redirect "#{ENV['STACK_PATH']}/log/puma.stdout.log", "#{ENV['STACK_PATH']}/log/puma.stderr.log"
stdout_redirect "#{ENV['STACK_PATH']}/log/puma.stdout.log", "#{ENV['STACK_PATH']}/log/puma.stderr.log", true


# on_worker_boot do
#   # Worker specific setup for Rails 4.1+
#   # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
#   ActiveRecord::Base.establish_connection
# end

# before_fork do
#   require 'puma_worker_killer'
#   PumaWorkerKiller.enable_rolling_restart
# end
prune_bundler

worker_timeout 15
worker_shutdown_timeout 8

