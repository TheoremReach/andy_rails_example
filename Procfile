custom_web: bundle exec puma -C config/puma.rb -b unix:///tmp/web_server.sock  --pidfile /tmp/web_server.pid 
worker: env RAILS_ENV=$RAILS_ENV REDIS_URL=redis://$REDIS_ADDRESS bundle exec sidekiq -C config/sidekiq.yml -t 20

