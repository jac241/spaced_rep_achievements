web: bundle exec rails server
acgrpc: bundle exec anycable
acws: anycable-go --rpc_host sra.acgrpc:5000 --enable_ws_compression
worker: bundle exec sidekiq
release: bin/rails db:migrate:with_data
